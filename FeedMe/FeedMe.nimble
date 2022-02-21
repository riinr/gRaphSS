# Package

version       = "0.1.0"
author        = "hugosenari"
description   = "RSS crawler"
license       = "MIT"
srcDir        = "src"
bin           = @["handler"]


# Dependencies

requires "nim >= 1.6.0"
requires "awslambda >= 0.2.0"
requires "FeedNim >= 0.2.1"
requires "https://github.com/glennj/feed-nim#cdata-handling"
requires "atoz >= 2626.1.0"
requires "crc32 >= 0.5.2"

