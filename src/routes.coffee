dsl = require './dsl'

cache = {}

route = (app) ->
  for path, func of cache
    makeRoute app, path, func

makeRoute = (app, path, func) ->
  method = func.method or 'get'
  app[method] path, (req, res, next) ->
    res.setHeader 'X-Powered-By', 'solid'
    # TODO: Also, print the response statusCode (with colors; use termcolor)
    console.log "[#{req.method}] #{req.path}"

    content = map req.route.path

    # If `content` is a function call it with the right scope (the `dsl` object)
    if typeof content is "function"
      content = content.call dsl, req, res
    # If `content` is a string and looks like an URL, then we redirect to that URL
    else if typeof content is "string" and content[0] is '/'
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

# Wipes the routes.
clean = ->
  cache = {}

# Returns a hash of paths mapped to paths or functions.
build = (paths...) ->
  prefix = ""
  build_recurse(prefix, paths...)

build_recurse = (prefix, paths...) ->
  for path in paths
    switch typeof(path)
      when "object" # Hash
        for pathName, value of path
          type = typeof(value)
          if type is "object" # Hash again
            build_recurse "#{prefix}/#{pathName}/", value
          else
            value = normalizePath value  if type is "string"
            bind prefix + pathName, value
      when "string"
        path = normalizePath prefix + path
        bind path, path
      else
        throw new Error "I don't understand this path: #{path}"
  cache

bind = (path, value) ->
  path = normalizePath path
  cache[path] = value

normalizePath = (path) ->
  path = "/#{path}"
  # Repeated forward slashes ('////') translate to one slash ('/')
  path = path.replace(/\/{2,}/g, "/")
  # Ending slashes are removed entirely. The beginning slash is preserved.
  path = path.replace(/(?!^)\/+$/g, "")

map = (path) ->
  cache[path]

module.exports = {clean, build, map, route}