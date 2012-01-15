fs = require 'fs'
thermos = require 'thermos'

dsl = module.exports = {}

# Add the basic request methods, plus any aliases, to the DSL
# so the user can use the methods as @get, @create, etc.
methods =
  'get'    : []
  'post'   : [ 'create' ]
  'put'    : [ 'update' ]
  'delete' : [ 'del' ]

for method, aliases of methods
  do (method) ->
    action = (func) ->
      func.method = method
      func
    aliases.push method
    for alias in aliases
      dsl[alias] = action
      
# Add a render method to the DSL, delegated to thermos.
# TODO: Make this plugin-able (let people use jade or whatever form of templating they prefer)
dsl.render = (opts, func) ->
  if arguments.length is 1
    func = opts
    opts = {}
  (req, res) ->
    opts.locals = req or {}
    thermos.render(opts, func)
    
# External library support
# @jquery will give you the code of the latest jQuery library
dsl.jquery = () ->
  type: 'text/javascript'
  body: fs.readFileSync './external-libs/jquery.min.js', 'utf8'