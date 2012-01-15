solid  = require '../src/solid'
fs     = require 'fs'
http   = require 'http'
should = require 'should'


# Configuration

PORT = solid.DEFAULT_PORT
HOST = "localhost"
        
# HTTP client testing helpers
# TODO: This doesn't handle errors all that well

get = (path, cb, port=PORT) ->
  data = ""
  http.get {host: 'localhost', port:port, path:path}, (res) ->
    res.on 'data', (chunk) -> data += chunk
    res.on 'end', -> cb res, data
  
# Tests
# =====

describe "server working", ->
  describe "basic", ->
    it "should return some HTML with a 200 status code", (done) ->
      homeHTML = "<b>hello world!</b>"
      
      server = solid ->
                "/"          : -> homeHTML
                "jquery"     : @jquery
            
      get "/", (res, data) ->
        res.statusCode.should.equal 200
        data.should.equal homeHTML
        
        get "/jquery", (res, data) ->
          res.headers['content-type'].should.equal 'text/javascript'
          res.statusCode.should.equal 200
          data.should.equal fs.readFileSync './external-libs/jquery.min.js', 'utf8'
          server.close()
          done()
          
  describe "redirects", ->
    it "should redirect and return a 302", (done) ->    
      server = solid ->
                "/"          : -> "home"
                "/home"      : "/"
      
      get "/home", (res, data) ->
        res.statusCode.should.equal 302
        res.headers.location.should.equal "http://#{HOST}:#{PORT}/"
        server.close()
        done()
  
  describe "server configuration", ->
    it "should start a server on a port other than the specified port rather than the default one", (done) ->
      port = 65432
      server = solid {port: port}, ->
                  "/" : -> "home"
      get "/", ((res, data) ->
          res.statusCode.should.equal 200
          data.should.equal "home"
          server.close()
          done()),
        port