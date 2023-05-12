import std/[json, os, sequtils, strutils, times]
import awslambda
import graphql

const SCHEMA_DIR = currentSourcePath().parentDir.parentDir & "/schemas"

let ctx = new GraphqlRef
when defined release:
  const SCHEMA_HEADER =   staticRead(SCHEMA_DIR & "/schema.ql")
  const SCHEMA_QUERY =    staticRead(SCHEMA_DIR & "/query.ql")
  const SCHEMA_MUTATION = staticRead(SCHEMA_DIR & "/mutation.ql")
  const SCHEMA = SCHEMA_HEADER & "\n" & SCHEMA_QUERY & "\n" & SCHEMA_MUTATION
  discard ctx.parseSchema(SCHEMA)
else:
  let schemaHeader =    open(SCHEMA_DIR & "/schema.ql").readAll
  let schemaQuery =     open(SCHEMA_DIR & "/query.ql").readAll
  let schemaMutation =  open(SCHEMA_DIR & "/mutation.ql").readAll
  let schema = schemaHeader & "\n" & schemaQuery & "\n" & schemaMutation
  let schemaValidation = ctx.parseSchema(schema)
  assert schemaValidation.isOk, $schemaValidation

proc handler(event: JsonNode): JsonNode =
  let startAt = cpuTime()
  let validation = ctx.parseQuery(event["body"].getStr)
  if validation.isErr:
    return % {
      "statusCode": % 400,
      "body": % {
        "code": % 400,
        "messages": % validation.error.mapIt($it)
      }
    }

  result = % {
    "statusCode": % 200,
    "body": % "bode"
  }
  echo "handler total: ", cpuTime() - startAt, "ms"


when isMainModule:
  let memory = "AWS_LAMBDA_FUNCTION_MEMORY_SIZE".getEnv.parseInt
  if memory > 0:
    proc awsHandler(event: JsonNode, context: LambdaContext): JsonNode =
      event.handler

    awsHandler.startLambda
    quit 0

  if paramCount() < 1:
    echo """
    USAGE:
    CRQwnS event1.json [eventN.json]

    Where event1.json should be a file with aws api gateway websocket event json
    """
    quit 1

  for i in 1..paramCount():
    echo paramStr(i).parseFile.handler
