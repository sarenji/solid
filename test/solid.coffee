solid  = require '../src/solid'
fs     = require 'fs'
http   = require 'http'
should = require 'should'


# Configuration

PORT = solid.DEFAULT_PORT
HOST = "127.0.0.1"

# HTTP client testing helpers

get = (path, options, callback) ->
  if not callback
    callback = options
    options  = null
  options ?= { port : PORT }

  data = ""
  port = options.port
  console.log "About to do a GET on #{HOST}:#{port}#{path}"
  request = http.get host: HOST, port: port, path: path, (res) ->
    res.on 'data', (chunk) -> data += chunk
    res.on 'end', -> callback res, data
  request.on 'error', (error) ->
    console.error "Error in GET request:"
    console.error error.stack

# Tests
# =====

describe "server", ->
  # describe "basic", ->
  #   it "should return some HTML with a 200 status code", (done) ->
  #     homeHTML = "<b>hello world!</b>"
  #
  #     server = solid ->
  #               "/"          : -> homeHTML
  #               "jquery"     : @jquery
  #
  #     console.log "Started server"
  #
  #     get "/", (res, data) ->
  #       console.log "Got some data #{data}"
  #       res.statusCode.should.equal 200
  #       data.should.equal homeHTML
  #
  #       get "/jquery", (res, data) ->
  #         res.headers['content-type'].should.equal 'text/javascript'
  #         res.statusCode.should.equal 200
  #         data.should.equal fs.readFileSync './external-libs/jquery.min.js', 'utf8'
  #         server.close()
  #         done()

  describe "redirects", ->
    it "should redirect and return a 302", (done) ->
      callback = ->
        get "/home", (res, data) ->
          res.statusCode.should.equal 302
          res.headers.location.should.equal "http://#{HOST}:#{PORT}/"
          server.close()
          done()
      server = solid callback: callback, ->
                "/"          : -> "home"
                "/home"      : "/"

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

      server = solid port: port, callback: callback, ->
                  "/" : -> "home"