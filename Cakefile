{exec} = require 'child_process'

task 'build', 'Build lib from src', ->
    exec './node_modules/coffeescript/bin/coffee --compile --map --output lib src', (err, stdout) ->
        console.log stdout
        throw err if err

task 'test', 'Run library tests', ->
    exec './node_modules/mocha/bin/mocha --compilers coffee:coffeescript/register -R spec --colors test/*.coffee', (err, stdout) ->
        console.log stdout
        throw err if err