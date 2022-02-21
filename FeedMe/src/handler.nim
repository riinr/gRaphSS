import std/[asyncdispatch, json, os, strutils, sequtils, times]
import awslambda
import feedsource
import dynamodb

proc saveItems(source: FeedSource): Future[int] {.async.} =
  let
    feedItems = await source.items
    saves = feedItems.toSeq.map save
  discard await saves.all
  return feedItems.len

proc updateNews(urlsResponse: JsonNode): Future[JsonNode] {.async.} =
  let startAt = cpuTime()
  let feeds = urlsResponse.getOrDefault "Items"
  result = % feeds.isNil
  if not feeds.isNil:
    let 
      feedSources = feeds.items.toSeq.map newFeedSource
      saves = feedSources.map saveItems
    discard await saves.all
  echo "updateNews : ", cpuTime() - startAt

proc scheduleNext(urlsResponse: JsonNode): Future[JsonNode] {.async.} =
  let lastKey = urlsResponse.getOrDefault "LastEvaluatedKey"
  if not lastKey.isNil:
    echo "lastKey ", lastKey
  return %* lastKey.isNil

proc localHandler(event: JsonNode): JsonNode =
  let startAt = cpuTime()
  let 
    urlsResponse = getUrls(event)
    news = urlsResponse.updateNews
    nextSchedule = urlsResponse.scheduleNext
    content = waitFor all(news, nextSchedule)
  result = %* content
  echo "handler total: ", cpuTime() - startAt

proc handler(event: JsonNode, context: LambdaContext): JsonNode =
  event.localHandler

when isMainModule:
  let memory = "AWS_LAMBDA_FUNCTION_MEMORY_SIZE".getEnv.parseInt
  if memory > 0:
    handler.startLambda
  else:
    echo newJObject().localHandler
