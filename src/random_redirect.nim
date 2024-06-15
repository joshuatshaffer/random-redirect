import prologue
import karax/[karaxdsl, vdom]
import random
import std/httpclient

proc getContent(url: string): string =
  var client = newHttpClient()
  try:
    result = client.getContent(url)
  finally:
    client.close()

const links = [
  "/example/one",
  "/example/two",
  "/example/three",
]

proc hello*(ctx: Context) {.async.} =
  let x = buildHtml(html(lang = "en")):
    head:
      meta(charset = "UTF-8", name = "viewport",
          content = "width=device-width, initial-scale=1")
      title: text "Simple Chat"
    body:
      h1: text "Hello, World!"
      a(href = "/random"): text "Random"
      pre: text getContent("https://joshuatshaffer.com/sitemap.xml")
  resp htmlResponse("<!DOCTYPE html>\n" & $x)

proc randomRedirect*(ctx: Context) {.async.} =
  resp redirect(links[rand(links.high)])

# Initialize the random number generator
randomize()

let app = newApp()
app.get("/", hello)
app.get("/random", randomRedirect)
app.run()
