fs = require 'fs'
thermos = require 'thermos'

dsl = module.exports = {}

# Add a render method to the DSL, delegated to thermos.
# TODO: Make this plugin-able (let people use jade or whatever form of templating they prefer)
dsl.render = (opts, func) ->
  if not func
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