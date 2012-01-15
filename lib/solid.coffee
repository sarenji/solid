express = require 'express'
dsl     = require './dsl'

port = process.env.PORT or 8080
solid = module.exports = (func) ->
  paths = func.call(dsl)
  routes.build paths
  server = createServer()
  server.listen port
  console.log "Solidified port #{port}"

createServer = ->
  app = express.createServer()

  # app.static "#{__dirname}/public", maxAge : 0

  # map routes
  for path, action of routes.cache
    method = action.method or 'get'
    app[method] path, (req, res, next) ->
      content = routes.map req.route.path
      while typeof(content) is "function"
        content = content.call dsl, req, res
      console.log "CONTENT: #{content}"
      if not content then return
      res.writeHead 200, 'Content-Type' : 'text/html'
      res.end content, 'utf-8'

  # return created server
  app

routes =
  cache : {}

  # Wipes the routes.
  clean : ->
    routes.cache = {}

  # Returns a hash of paths mapped to paths or functions.
  build : (paths...) ->
    prefix = ""
    routes.build_recurse(prefix, paths...)

  build_recurse : (prefix, paths...) ->
    for path in paths
      switch typeof(path)
        when "object" # Hash
          for pathName, value of path
            type = typeof(value)
            if type is "object" # Hash again
              routes.build_recurse "#{prefix}/#{pathName}/", value
            else
              value = routes.normalizePath value  if type is "string"
              routes.bind prefix + pathName, value
        when "string"
          path = routes.normalizePath prefix + path
          routes.bind path, path
        else
          throw new Error "I don't understand this path: #{path}"
    routes.cache

  bind : (path, value) ->
    path = routes.normalizePath path
    routes.cache[path] = value

  normalizePath : (path) ->
    path = "/#{path}"
    path = path.replace(/\/{2,}/g, "/")
    path = path.replace(/(?!^)\/+$/g, "")

  map : (path) ->
    routes.cache[path]

solid.routes =
  clean : routes.clean
  build : routes.build
  map   : routes.map

solid.createServer = createServer