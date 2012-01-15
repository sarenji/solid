solid  = require '../src/solid'
fs     = require 'fs'
http   = require 'http'
should = require 'should'


# Configuration

PORT = 8080
HOST = "localhost"
        
# HTTP client testing helpers
# TODO: This doesn't handle errors all that well

get = (path, cb) ->
  data = ""
  http.get {host: 'localhost', port:PORT, path:path}, (res) ->
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
      solid ->
        "/"          : -> homeHTML
        "/home"      : "/"
      
      get "/home", (res, data) ->
        res.statusCode.should.equal 302
        res.headers.location.should.equal "http://#{HOST}:#{PORT}/"
        done()
  
  describe "server configuration", ->