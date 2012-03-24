solid = require '../src/solid'

solid (app) ->
  app.get "/", ->
    # The default folder for templates is './views'.
    @jade 'index', views: 'examples/static'
