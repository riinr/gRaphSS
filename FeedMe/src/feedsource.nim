import std/[asyncdispatch, httpclient, json, options, strutils, sequtils, times]
import FeedNim/[atom, rss, jsonfeed]
import crc32

type FeedKind* = enum
  FK_ATOM,
  FK_JSON,
  FK_RSS,
  FK_UNKNOWN

type SourceContent* = object
  case kind*: FeedKind
  of FK_ATOM:
    atom: ATOM
  of FK_JSON:
    json: JSONFeed
  of FK_RSS:
    rss: RSS
  of FK_UNKNOWN:
    text: string

proc len(content: SourceContent): int =
  if content.kind == FK_ATOM:
    content.atom.entries.len
  elif content.kind == FK_JSON:
    content.json.items.len
  elif content.kind == FK_RSS:
    content.rss.items.len
  else:
    return 0

type FeedSource* = ref object
  meta*: JsonNode
  contentResolved: Option[SourceContent]

proc newFeedSource*(meta: JsonNode): FeedSource =
  FeedSource(
    meta: meta,
    contentResolved: none(SourceContent)
  )

proc url*(source: FeedSource): string =
  source.meta["xmlUrl"]["S"].getStr

proc request(source: FeedSource): Future[AsyncResponse] =
  newAsyncHttpClient().request source.url

proc fetchFeed*(source: FeedSource): Future[SourceContent] {.async.} =
  let 
    response = await source.request
    text = await response.body
  if text.contains "<rss":
    try:
      return SourceContent(kind: FK_RSS, rss: parseRSS(text))
    except Exception as e:
      echo "Isn't RSS"
      echo getCurrentExceptionMsg()
      echo e.getStackTrace()
  if text.contains "<feed":
    try:
      return SourceContent(kind: FK_ATOM, atom: parseAtom(text))
    except Exception as e:
      echo "Isn't ATOM"
      echo getCurrentExceptionMsg()
      echo e.getStackTrace()
  if text.contains "https://jsonfeed.org/version/":
    try:
      return SourceContent(kind: FK_JSON, json: parseJSONFeed(text))
    except Exception as e:
      echo "Isn't JSONFeed"
      echo getCurrentExceptionMsg()
      echo e.getStackTrace()
  return SourceContent(kind: FK_UNKNOWN, text: text)

proc content(source: FeedSource): Future[SourceContent] {.async.} =
  if source.contentResolved.isNone:
    source.contentResolved = some(await source.fetchFeed)
  return source.contentResolved.get

proc kind*(source: FeedSource): Future[FeedKind] {.async.} =
  let content = await source.content
  return content.kind

proc len*(source: FeedSource): Future[int] {.async.} =
  let content = await source.content
  return content.len

type FeedItem* = JsonNode

proc idOrGuid(item: RSSItem): string =
  var id = item.link
  crc32(id)
  return id

proc idOrGuid(item: AtomEntry): string =
  var id = item.link.href
  crc32(id)
  return id

proc idOrGuid(item: JSONFeedItem): string =
  var id = item.url
  crc32(id)
  return id

proc feedItem(source: FeedSource): FeedItem =
  let
    currentTime = now().toTime
    liveUntil = currentTime + 30.days
  %* {
    "imported_at": currentTime.toUnix,
    "unread_since": currentTime.toUnix,
    "live_until": liveUntil.toUnix,
    "parent": source.meta["uid"]["S"]
  }

proc feedItem(item: RSSItem, source: FeedSource): FeedItem =
  result = feedItem(source)
  result["uid"] = %* item.idOrGuid
  result["link"] = %* item.link
  result["title"] = %* item.title
  result["author"] = %* item.author
  result["published"] = %* item.pubDate
  result["content"] = %* item.description

proc feedItem(item: AtomEntry, source: FeedSource): FeedItem =
  result = feedItem(source)
  result["uid"] = %* item.idOrGuid
  result["link"] = %* item.link.href
  result["title"] = %* item.title.text
  result["summary"] = %* item.summary
  result["author"] = %* item.author.name
  result["published"] = %* item.published
  result["updated"] = %* item.updated
  result["content"] = %* item.content.text

proc feedItem(item: JSONFeedItem, source: FeedSource): FeedItem =
  result = feedItem(source)
  result["uid"] = %* item.idOrGuid
  result["link"] = %* item.url
  result["title"] = %* item.title
  result["summary"] = %* item.summary
  result["author"] = %* item.author.name
  result["published"] = %* item.date_published
  result["updated"] = %* item.date_modified
  result["content"] = %* item.content_text

iterator list(content: SourceContent, source: FeedSource): FeedItem =
  if content.kind == FK_ATOM:
    for item in content.atom.entries:
      yield item.feedItem source
  elif content.kind == FK_JSON:
    for item in content.json.items:
      yield item.feedItem source
  elif content.kind == FK_RSS:
    for item in content.rss.items:
      yield item.feedItem source

proc items*(source: FeedSource): Future[seq[FeedItem]] {.async.} =
  let content = await source.content
  return content.list(source).toSeq
