solid  = require '../src/solid'
fs     = require 'fs'

{get} = require './helpers/http'
{HOST, PORT} = require './helpers/config'

describe "server", ->
  describe "basic", ->
    it "should return some HTML with a 200 status code", (done) ->
      homeHTML = "<b>hello world!</b>"
      callback = ->
        get "/", (res, data) ->
          res.statusCode.should.equal 200
          data.should.equal homeHTML

          get "/jquery", (res, data) ->
            res.headers['content-type'].should.equal 'text/javascript'
            res.statusCode.should.equal 200
            data.should.equal fs.readFileSync './external-libs/jquery.min.js', 'utf8'
            server.close()
            done()

      server = solid callback: callback, (app) ->
        app.get "/", -> homeHTML
        app.get "jquery", @jquery

  describe "redirects", ->
    it "should redirect and return a 302", (done) ->
      callback = ->
        get "/home", (res, data) ->
          res.statusCode.should.equal 302
          res.headers.location.should.equal "http://#{HOST}:#{PORT}/"
          server.close()
          done()
      server = solid callback: callback, (app) ->
        app.get "/", -> "home"
        app.get "/home", "/"

  describe "static files", ->
    it "should serve all files in the static option as static files", (done) ->
      done() # TODO

  describe "configuration", ->
    it "can take a port different from the default one", (done) ->
      port = 65432
      callback = ->
        get "/", port: port, (res, data) ->
          res.statusCode.should.equal 200
          data.should.equal "home"
          server.close()
          done()

      server = solid port: port, callback: callback, (app) ->
        app.get "/", -> "home"

  describe "namespaces", ->
    it "can have nested namespaces", (done) ->
      callback = ->
        get "/user/profile/1", (res, data) ->
          data.should.equal "#1"
          server.close()
          done()

      server = solid callback: callback, (app) ->
        app.namespace "/user", ->
          app.namespace "/profile", ->
            app.get "/:id", (req) -> "##{req.params.id}"

    it "uses the DSL within a namespace", (done) ->
      callback = ->
        get "/javascripts/jquery.js", (res, data) ->
          res.headers['content-type'].should.equal 'text/javascript'
          res.statusCode.should.equal 200
          data.should.equal fs.readFileSync './external-libs/jquery.min.js', 'utf8'
          server.close()
          done()

      server = solid callback: callback, (app) ->
        app.namespace "/javascripts", ->
          app.get '/jquery.js', @jquery

  describe "parameterized routes", ->
    it "doesn't return the same content", (done) ->
      callback = ->
        get "/1", (res, data) ->
          data.should.equal "#1"
          get "/2", (res, data) ->
            data.should.equal "#2"
            server.close()
            done()

      server = solid callback: callback, (app) ->
        app.get '/:id', (req) -> "##{req.params.id}"
