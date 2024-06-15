# Package

version       = "0.1.0"
author        = "Joshua Shaffer"
description   = "A server that redirects to a random URL."
license       = "MIT"
srcDir        = "src"
bin           = @["random_redirect"]


# Dependencies

requires "nim >= 2.0.4"
requires "prologue >= 0.6.6"
requires "karax >= 1.3.3"
