typeOf = (obj) ->
  Object.prototype.toString.call(obj).slice 8, -1

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
      switch typeOf(path)
        when "Object" # Hash
          for pathName, value of path
            if typeOf(value) is "Object" # Hash again
              routes.build_recurse prefix + pathName, value
            else
              routes.bind prefix + pathName, value
        when "String"
          routes.bind prefix + path, path
        else
          throw new Error "I don't understand this path: #{path}"
    routes.cache

  bind : (path, value) ->
    routes.cache[path] = value

  map : (path) ->
    routes.cache[path]

@routes =
  clean : routes.clean
  build : routes.build
  map   : routes.map