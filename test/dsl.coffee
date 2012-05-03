dsl    = require '../src/dsl'

describe "the dsl", ->
  describe "@render", ->
    it "should create a function that returns html via thermos", ->
      func = dsl.render ->
        @p ->
          @span "you so fancy"
      func.call(null).should.equal "<p><span>you so fancy</span></p>"

    it "can get passed a request object", ->
      func = dsl.render (req) ->
        @p -> req.params.test
      func.call(null, params : { test: "hi" })
      .should.equal "<p>hi</p>"

    it "should take options to delegate to thermos", ->
      helpers =
        test : -> @p arguments...

      func = dsl.render helpers: helpers, ->
        @test ->
          @span "you so fancy"
      func.call(null).should.equal "<p><span>you so fancy</span></p>"

  describe "@jquery", ->
    it "should output the contents of the latest version of jQuery", ->
      # Check against a random of piece of code that's *usually* found in jQuery source code
      i = dsl.jquery().body.indexOf "return f.isWindow(a)?a:a.nodeType===9?a."
      i.should.above -1

    it "should be served as javascript", ->
      dsl.jquery().type.should.equal 'text/javascript'

  describe "@haml", ->
    it "renders a file and outputs HTML", ->
      dsl.haml('example', views: 'test/fixtures').should.equal '<!DOCTYPE html>\n<html><head><title>Fixture</title></head><body><p>Hello world!</p></body></html>'

  describe "@jade", ->
    it "renders a file and outputs HTML", ->
      dsl.jade('example', views: 'test/fixtures').should.equal '<!DOCTYPE html><html><head><title>Fixture</title></head><body><p>Hello world!</p></body></html>'

  describe "@sass", ->
    it "renders a file and outputs CSS", ->
      dsl.sass('example', views: 'test/fixtures').should.equal '#header p {\n  color: red;}\n'
