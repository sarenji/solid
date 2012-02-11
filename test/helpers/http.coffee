http = require 'http'

# Configuration
{HOST, PORT} = require './config'

# HTTP client testing helpers

@get = get = (path, options, callback) ->
  if not callback
    callback = options
    options  = null
  options ?= { port : PORT }

  data = ""
  port = options.port
  request = http.get host: HOST, port: port, path: path, (res) ->
    res.on 'data', (chunk) -> data += chunk
    res.on 'end', -> callback res, data
  request.on 'error', (error) ->
    console.error "Error in GET request:"
    console.error error.stack