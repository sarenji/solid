dsl     = require './dsl'
{Router} = require('./routes')
express = require 'express'

# Defaults
DEFAULT_PORT = 8081

port = process.env.PORT or DEFAULT_PORT

# Returns the Express server backing Solid
solid = module.exports = (options, func) ->
  if not func
    func = options
    options = {}
  options.port ?= port

  # Create the server and pass in options
  server = createServer options

  # Map routes; use DSL as the context
  func.call(dsl, new Router(server))

  # Start listening for connections
  server.listen options.port, options.host, options.callback
  console.log "Solidified port #{options.port}"

  # Return this server instance
  server

createServer = (options) ->
  app = express.createServer()

  if 'cwd' of options
    staticDir = "#{options.cwd}/static"
    console.log "Serving static files from #{staticDir}"
    # TODO: In prod, it's bad to have a maxAge of zero
    app.use '/static', express.static(staticDir, maxAge : 0)

  # return created server
  app

solid.routes = require './routes'
solid.createServer = createServer
solid.DEFAULT_PORT = DEFAULT_PORT