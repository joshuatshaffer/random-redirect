import prologue
import karax/[karaxdsl, vdom]
import random
import getSitemap

const sitemapUrl = "https://joshuatshaffer.com/sitemap.xml"

proc hello(ctx: Context) {.async.} =

  let links = getSitemap(sitemapUrl)

  let x = buildHtml(html(lang = "en")):
    head:
      meta(charset = "UTF-8", name = "viewport",
          content = "width=device-width, initial-scale=1")
      title: text "Simple Chat"
    body:
      h1: text "Hello, World!"
      a(href = ctx.urlFor("random")): text "Random"
      ul:
        for link in links:
          li: a(href = link): text link
  resp htmlResponse("<!DOCTYPE html>\n" & $x)

proc randomRedirect(ctx: Context) {.async.} =
  # TODO: Cache the links so they are not fetched on every request.
  let links = getSitemap(sitemapUrl)

  ctx.response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate")

  resp redirect(links[rand(links.high)], code = Http302)

# Initialize the random number generator
randomize()

let app = newApp()
app.get("/", hello)
app.get("/random", randomRedirect, name = "random")
app.run()
