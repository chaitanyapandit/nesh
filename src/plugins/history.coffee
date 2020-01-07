###
History Plugin - adds persistent history to the interpreter so
long as no `.history` command has already been defined.

This plugin adds two new options:

 * historyFile: the filename of where to store history lines
 * historyMaxInputSize: Maximum number of bytes to load from
                        the history file

History support can be disabled by setting `historyFile` to
null or false in the interpreter options on startup:

    nesh.start({historyFile: null}, function (err) { ... });

###
fs = require 'fs'
path = require 'path'

exports.name = 'history'
exports.description = 'Provides persistent history between sessions'

exports.setup = (context) ->
    {defaults, config} = context.nesh
    defaults.historyFile ?= path.join(config.home, '.node_history')
    defaults.historyMaxInputSize ?= 10240

exports.postStart = (context) ->
    {repl} = context
    
    # Skip if we have no file to use
    return unless repl.opts.historyFile

    # Skip if a `.history` command is already setup
    return if repl.commands['.history']

    maxSize = repl.opts.historyMaxInputSize
    lastLine = null
    try
        # Get file info and at most maxSize of command history
        stat = fs.statSync repl.opts.historyFile
        size = Math.min maxSize, stat.size
        # Read last `size` bytes from the file
        readFd = fs.openSync repl.opts.historyFile, 'r'
        buffer = Buffer.alloc(size)
        fs.readSync readFd, buffer, 0, size, stat.size - size
        # Set the history on the interpreter
        repl.history = buffer.toString().split('\n').reverse()
        # If the history file was truncated we should pop off a potential partial line
        repl.history.pop() if stat.size > maxSize
        # Shift off the final blank newline
        repl.history.shift() if repl.history[0] is ''
        repl.historyIndex = -1
        lastLine = repl.history[0]

    fd = fs.openSync repl.opts.historyFile, 'a'

    repl.addListener 'line', (code) ->
        if code and code.length and code isnt '.history' and lastLine isnt code
            # Save the latest command in the file
            fs.write fd, "#{code}\n", ->
            lastLine = code

    repl.on 'exit', -> fs.close fd, ->

    # Add a command to show the history stack
    cmd =
        help: 'Show command history'
        action: ->
            repl.outputStream.write "#{repl.history[..].reverse().join '\n'}\n"
            repl.displayPrompt()
    repl.defineCommand 'history', cmd
