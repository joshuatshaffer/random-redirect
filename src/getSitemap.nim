import std/httpclient
import parsexml, strutils

proc getSitemap*(url: string): seq[string] =
  ## Return a list of URLs from a sitemap file.
  var client = newHttpClient()
  var x: XmlParser
  result = @[]
  try:
    var resp = client.get(url)

    if not resp.code.is2xx:
      echo("Could not get " & url & " " & $resp.status)
      return

    x.open(resp.bodyStream, url)
    block mainLoop:
      while true:
        x.next()
        case x.kind
          of xmlElementStart:
            if cmpIgnoreCase(x.elementName, "loc") == 0:
              var loc = ""
              block readLoc:
                while true:
                  x.next()
                  case x.kind
                    of xmlCharData:
                      loc.add(x.charData)
                    of xmlElementEnd:
                      if cmpIgnoreCase(x.elementName, "loc") == 0:
                        result.add(loc)
                        break readLoc
                    of xmlEof:
                      result.add(loc)
                      break mainLoop
                    else:
                      discard
          of xmlEof:
            break mainLoop
          else:
            discard

  finally:
    x.close()
    client.close()
