###
Welcome Message Plugin
======================
This plugin adds a new option to the repl opts called `welcome` that,
if set, will display the set string before starting the interpreter.
The welcome message can be set like so:

    nesh.start {welcome: 'Hello!'}, (err) ->
        console.log err if err

###
require 'colors'

exports.name = 'welcome'
exports.description = 'Displays a welcome message on startup'

# Plugin setup - run when the plugin is loaded
# This adds a new setting to the default options
exports.setup = (context) ->
    {defaults} = context.nesh
    defaults.welcome ?= "Node #{process.version}\nType " +
        ".help".cyan + " for more information"

# The preStart action - run before the repl is started
# If a welcome message is set, then output it on the repl's
# output stream.
exports.preStart = (context) ->
    {options} = context
    if options.welcome
        outStream = options.outputStream or process.stdout
        outStream.write "#{options.welcome}\n"
