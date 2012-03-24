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

# jade plugin
dsl.jade = (template, options = {}, locals = {}) ->
  options.method ||= 'compile'
  render 'jade', template, options, locals

# sass plugin
dsl.sass = (template, options = {}, locals = {}) ->
  options.method ||= 'render'
  render 'sass', template, options

# Abstract common render use.
render = (engine, template, options, locals) ->
  extension = options.extension || engine
  views = options.views || 'views'
  method = options.method
  template = normalize(template, extension)

  # Memoize the compiled template
  # TODO: Not scalable
  if template not of compiled
    includes[engine] ?= require(engine)
    contents = readFile(template, views)
    renderer = if method? then includes[engine][method] else includes[engine]
    compiled[template] = renderer(contents)

  if locals?
    # Run the compiled template with passed locals
    compiled[template](locals)
  else
    # Just return the compiled template
    compiled[template]

normalize = (url, extension) ->
  urlExtension = url.split('.').pop()
  if extension == urlExtension then url
  else "#{url}.#{extension}"

readFile = (filePath, views) ->
  filePath = filePath.replace(/^\/\/*/, '')
  fullPath = path.join(process.cwd(), views, filePath)
  fs.readFileSync(fullPath, 'utf8')
