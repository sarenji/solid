dsl = module.exports = {}

# Add the basic request methods, plus any aliases, to the DSL
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
dsl.render = (opts, func) ->
  if arguments.length is 1
    func = opts
    opts = {}
  (req, res) ->
    opts.locals = req or {}
    require('thermos').render(opts, func)