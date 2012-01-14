dsl    = require '../lib/dsl'
should = require 'should'

describe "the dsl", ->
  func = null
  beforeEach ->
    func = ->
  describe "@get request", ->
    it "should return a function with the method set to GET", ->
      dsl.get func
      func.method.should.equal 'get'

  describe "@post request", ->
    it "should return a function with the method set to POST", ->
      dsl.post func
      func.method.should.equal 'post'

    it "should be aliased to @create", ->
      dsl.create func
      func.method.should.equal 'post'

  describe "@put request", ->
    it "should return a function with the method set to PUT", ->
      dsl.put func
      func.method.should.equal 'put'

    it "should be aliased to @update", ->
      dsl.update func
      func.method.should.equal 'put'

  describe "@delete request", ->
    it "should return a function with the method set to DELETE", ->
      dsl.delete func
      func.method.should.equal 'delete'

    it "should be aliased to @del", ->
      dsl.del func
      func.method.should.equal 'delete'

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