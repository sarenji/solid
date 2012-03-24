solid  = require '../../src/solid'
nodeload = require 'nodeload'
should = require 'should'

{get} = require '../helpers/http'
{HOST, PORT} = require '../helpers/config'

WANTED_RPS  = 2000
TIME_LIMIT  = process.env.TIME_LIMIT || 60 # secs
NUM_CLIENTS = 500

# Create server
server = solid port: PORT, (app) ->
  app.get "/", ->
    @jade "example", views: 'test/fixtures'

loadtest = nodeload.run
  host: HOST
  port: PORT
  numClients: NUM_CLIENTS
  timeLimit: TIME_LIMIT
  targetRps: WANTED_RPS
  path: "/"
  method: "GET"
  requestData: ''

# Close server and end test
loadtest.on 'end', ->
  server.close()
  process.exit(0)
