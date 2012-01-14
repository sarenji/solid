solid = require '../lib/solid'
should = require 'should'

beforeEach ->
  solid.routes.clean()

describe "passing one argument of", ->
  describe "a number", ->
    it "should throw an exception", ->
      -> solid.routes.build(1)
      .should.throw()

  describe "a string", ->
    it "should serve the file denoted by that string", ->
      routes = solid.routes.build "index.html"
      routes.should.eql "/index.html" : "/index.html"

  describe "a hash", ->
    it "should serve the file denoted by the value", ->
      world = -> "world.html"
      routes = solid.routes.build
        "index.html" : "other.html"
        "hello.html" : world
      routes.should.eql
        "/index.html" : "/other.html"
        "/hello.html" : world

    it "should support nested routes", ->
      routes = solid.routes.build
        "/site" :
          "" : "index.html"
          "/about" : "about.html"
      routes.should.eql
        "/site" : "/index.html"
        "/site/about" : "/about.html"

describe "passing multiple arguments of", ->
  describe "strings", ->
    it "should serve all of them", ->
      routes = solid.routes.build "index.html", "index2.html"
      routes.should.eql
        "/index.html"  : "/index.html"
        "/index2.html" : "/index2.html"

  describe "strings and hashes", ->
    it "should serve all of them", ->
      routes = solid.routes.build(
        "index.html"
        "foo.html" : "bar.html"
        "hello.html"
      )
      routes.should.eql
        "/index.html"  : "/index.html"
        "/foo.html"    : "/bar.html"
        "/hello.html"  : "/hello.html"

describe "routes", ->
  beforeEach ->
    solid.routes.build "index.html"

  describe "passed a hit", ->
    it "should return the result", ->
      result = solid.routes.map "/index.html"
      result.should.equal "/index.html"

  describe "passed a miss", ->
    it "should return a null", ->
      result = solid.routes.map "bogus.html"
      should.equal null, result

describe "route paths", ->
  it "should be normalized", ->
    func = -> "hello world"
    routes = solid.routes.build
      "/" : func
      "/////thing///" : func
      "/test" :
        "/"       : func
        "/extra/" : func
      "implicitfolders" :
        "blah"    : func
      "/test2/" :
        "/"       : func
        "/extra/" : func
      "/test3/" :
        ""        : func
        "/extra"  : func
        "more"    : func
    routes.should.eql
      "/" : func
      "/thing" : func
      "/implicitfolders/blah" : func
      "/test" : func
      "/test/extra" : func
      "/test2" : func
      "/test2/extra" : func
      "/test3" : func
      "/test3/extra" : func
      "/test3/more" : func