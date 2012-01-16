solid = require '../src/solid'

solid {port: 9001, cwd: __dirname}, (app) ->
  app.get "/", -> "<b>hello world!</b>"
  app.get "/home", "/"           # URL rewriting/redirects
  app.get "/jquery.js", @jquery  # Put <script src="/jquery.js"></script> in HTML
  app.namespace "/user", ->
    app.get "/:id", @render (req) ->
      @p "Hi, #{req.params.id}!"

    app.get "/:id/requests", (req) ->
      "<p>#{req.params.id}: you have no requests.</p>"
