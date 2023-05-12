# Package

version     = "0.1.0"
author      = "hugosenari"
description = "RSS crawler and graphql api"
license     = "MIT"
srcDir      = "src"
bin         = @["CROwN", "CRQwnS"]


# Dependencies

requires "nim       >= 1.6.0"
requires "awslambda >= 0.2.0"
requires "atoz      >= 2626.1.0"

# CROwN: its a job that run in AWS 'CRON'
# Dependencies
requires "FeedNim   >= 0.2.1"
requires "crc32     >= 0.5.2"
requires "https://github.com/glennj/feed-nim#cdata-handling"

# CRQwnS: its a CQRS api with websocket and graphql
# Dependencies
requires "graphql   >= 0.2.20"
