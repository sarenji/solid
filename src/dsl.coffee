fs = require 'fs'
thermos = require 'thermos'
path = require 'path'

dsl = module.exports = {}
includes = {}
compiled = {}

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
  body: fs.readFileSync "#{__dirname}/../external-libs/jquery.min.js", 'utf8'

# haml plugin
dsl.haml = (template, options = {}, locals = {}) ->
  render 'haml', template, options, locals

# Abstract common render use.
render = (engine, template, options, locals) ->
  extension = options.extension || engine
  views = options.views || 'views'
  template = normalize(template, extension)

  # Memoize the compiled template
  # TODO: Not scalable
  if template not of compiled
    includes[engine] ?= require(engine)
    file = readFile(template, views)
    compiled[template] = includes[engine](file)

  # Run the compiled template with passed locals
  compiled[template](locals)

normalize = (url, extension) ->
  urlExtension = url.split('.').pop()
  if extension == urlExtension then url
  else "#{url}.#{extension}"

readFile = (filePath, views) ->
  filePath = filePath.replace(/^\/\/*/, '')
  fullPath = path.join(process.cwd(), views, filePath)
  fs.readFileSync(fullPath, 'utf8')
