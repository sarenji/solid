dsl  = require './dsl'
Path = require 'path'

methods =
  'get'    : []
  'post'   : [ 'create' ]
  'put'    : [ 'update' ]
  'delete' : [ 'del' ]

class Router
  constructor : (@app) ->
    @routes = {}
    @namespaces = []

  namespace : (path, fn) ->
    @namespaces.push(path)
    fn.call(dsl)
    @namespaces.pop()
    this

  for method, aliases of methods
    aliases.push method
    for alias in aliases
      do (method) =>
        @::[alias] = (path, content) ->
          fullPath = Path.join('/', @namespaces..., path)
          @app[method] fullPath, (req, res, next) ->
            res.setHeader 'X-Powered-By', 'solid'
            # TODO: Also, print the response statusCode (with colors; use termcolor)
            console.log "[#{req.method}] #{req.path}"

            # If `content` is a function, then
            # call it with the right scope (the `dsl` object)
            if typeof content is "function"
              content = content.call dsl, req, res
            # If `content` is a string and looks like an URL, then
            # redirect to that URL
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

module.exports = {Router}