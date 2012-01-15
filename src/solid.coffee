dsl     = require './dsl'
express = require 'express'
_       = require 'underscore'
_.mixin require('underscore.string')

# Defaults
# TODO: Shouldn't our default port be 80?
DEFAULT_PORT = 8080

port = process.env.PORT or DEFAULT_PORT

# Returns the Express server backing Solid
solid = module.exports = (options, func) ->
  if not func
    func = options
    options = port: port
  console.log options
  
  paths = func.call(dsl)
  routes.build paths
  server = createServer options
  server.listen options.port
  console.log "Solidified port #{options.port}"
  server

createServer = (options) ->
  app = express.createServer()

  if 'cwd' of options
    staticDir = "#{options.cwd}/static"
    console.log "Serving static files from #{staticDir}"
    app.use '/static', express.static(staticDir, maxAge : 0)

  # Map routes
  for path, action of routes.cache
    method = action.method or 'get'
    app[method] path, (req, res, next) ->
      
      # TODO: Also, print the response statusCode (with colors; use termcolor)
      console.log "[#{req.method}] #{req.path}"
      
      content = routes.map req.route.path
      
      # If `content` is a function call it with the right scope (the `dsl` object) 
      if typeof content is "function"
        content = content.call dsl, req, res
      # If `content` is a string and looks like an URL, then we redirect to that URL
      else if typeof content is "string" and _(content).startsWith '/'
        res.redirect content
        return
        
      if not content then return #TODO: Do something better than just return? Not sure what Express does with this
      
      if typeof content is "object"
        content.headers ?= {}
        if "type" of content then content.headers['Content-Type'] = content.type
        res.writeHead (content.statusCode or 200), content.headers
        res.end content.body, 'utf-8'
      else
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
    path = path.replace(/\/{2,}/g, "/") # Repeated forward slashes ('////') translate to one slash ('/')
    path = path.replace(/(?!^)\/+$/g, "") # 

  map : (path) ->
    routes.cache[path]

solid.routes =
  clean : routes.clean
  build : routes.build
  map   : routes.map

solid.createServer = createServer
solid.DEFAULT_PORT = DEFAULT_PORT