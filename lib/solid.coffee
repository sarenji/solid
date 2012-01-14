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
            type = typeOf(value)
            if type is "Object" # Hash again
              routes.build_recurse "#{prefix}/#{pathName}/", value
            else
              value = routes.normalizePath value  if type is "String"
              routes.bind prefix + pathName, value
        when "String"
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

@routes =
  clean : routes.clean
  build : routes.build
  map   : routes.map