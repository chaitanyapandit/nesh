require 'colors'

coffee = require 'coffee-script'

exports.setup = (nesh) ->
    nesh.repl = require 'coffee-script/lib/coffee-script/repl'
    process.versions['coffee-script'] = coffee.VERSION
    nesh.defaults.welcome = "CoffeeScript #{coffee.VERSION} on Node #{process.version}\nType " + '.help'.cyan + ' for more information'
    nesh.defaults.prompt = 'coffee> '
