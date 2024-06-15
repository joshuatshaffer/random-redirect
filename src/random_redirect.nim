import prologue
import karax/[karaxdsl, vdom]

proc hello*(ctx: Context) {.async.} =
  let x = buildHtml(html(lang = "en")):
    head:
      meta(charset = "UTF-8", name="viewport", content="width=device-width, initial-scale=1")
      title: text "Simple Chat"
    body:
      h1: text "Hello, World!"
  resp htmlResponse("<!DOCTYPE html>\n" & $x)

let app = newApp()
app.get("/", hello)
app.run()