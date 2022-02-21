import std/[asyncdispatch, httpclient, json, strformat, strutils, sequtils, times]
import atoz/dynamodb_20120810

proc notId(attr: string): bool =
  attr != "uid" and attr != "parent"

proc updateExpressions(it: string): string =
  fmt"{it} = :{it}"

proc dyn(value: JsonNode): JsonNode =
    if value.kind == JString:
      result = %* { "S": value }
    elif value.kind == JInt:
      result = %* { "N": $value }
    elif value.kind == JFloat:
      result = %* { "N": $value }
    elif value.kind == JBool:
      result = %* { "BOOL": value.getBool }
    elif value.kind == JNull:
      result = %* { "NULL": true }
    elif value.kind == JArray:
      result = %* { "L": newJArray() }
      for val in value.items:
        result["L"].add val.dyn
    elif value.kind == JObject:
      result = %* { "M": %* {} }
      for key, val in value.pairs:
        result["M"][key] = val.dyn

proc expressionAttributeValues(values: JsonNode): JsonNode =
  result = %* {}
  for key, val in values.pairs:
    if key.notId:
      result[fmt":{key}"] = val.dyn

proc save*(feedItem: JsonNode): Future[JsonNode] {.async.} =
  let startAt = cpuTime()
  result = feedItem
  let
    exps = feedItem.keys.toSeq.filter(notId).map updateExpressions
    upExp =  %* ("SET " & exps.join(","))
    key = %* { "uid": feedItem["uid"].dyn, "parent": feedItem["parent"].dyn }
    exAttVal = feedItem.expressionAttributeValues
    body = %* {
      "Key": key,
      "TableName": "ReSSt",
      "UpdateExpression": upExp,
      "ExpressionAttributeValues": exAttVal,
      "ConditionExpression": "attribute_not_exists(uid)"
    }
    request = updateItem.call(nil, nil, nil, nil, body)
  discard await request.issueRequest
  echo "save duration: ", feedItem["uid"], " ", cpuTime() - startAt

proc getUrls*(event:JsonNode): JsonNode =
  let startAt = cpuTime()
  let
    body = %* {
      "TableName": "ReSSt",
      "IndexName": "feeds",
      "FilterExpression": "attribute_exists(xmlUrl)"
    }
    request = scan.call(body, "20")
    response = waitfor request.issueRequest
    responseJson = waitFor response.body
  result = parseJson responseJson
  echo "getUrls Duration: ", cpuTime() - startAt
