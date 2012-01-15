dsl     = require './dsl'
express = require 'express'

# Defaults
# TODO: Shouldn't our default port be 80?
DEFAULT_PORT = 8081

port = process.env.PORT or DEFAULT_PORT

# Returns the Express server backing Solid
solid = module.exports = (options, func) ->
  if not func
    func = options
    options = null
  options.port ?= port

  paths = func.call(dsl)
  solid.routes.build paths
  server = createServer options
  server.listen options.port, options.host, options.callback
  console.log "Solidified port #{options.port}"
  server

createServer = (options) ->
  app = express.createServer()

  if 'cwd' of options
    staticDir = "#{options.cwd}/static"
    console.log "Serving static files from #{staticDir}"
    # TODO: In prod, it's bad to have a maxAge of zero
    app.use '/static', express.static(staticDir, maxAge : 0)

  # Map routes
  solid.routes.route app

  # return created server
  app

solid.routes = require './routes'

solid.createServer = createServer
solid.DEFAULT_PORT = DEFAULT_PORT