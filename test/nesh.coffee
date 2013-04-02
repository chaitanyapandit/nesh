assert = require 'assert'

describe 'nesh', ->
    it 'should import without error', ->
        require '../lib/nesh'

    it 'should start without error and produce output', (done) ->
        nesh = require '../lib/nesh'

        # Create a dummy output stream to catch output
        output = ''
        opts = 
            outputStream:
                write: (data) ->
                    output += data

        nesh.start opts, (err) ->
            assert.equal false, err?
            assert.ok output
            done()

describe 'languages', ->
    it 'should load coffee-script', ->
        nesh = require '../lib/nesh'
        nesh.loadLanguage 'coffee'

    it 'should load a language via a function', (done) ->
        nesh = require '../lib/nesh'
        nesh.loadLanguage ->
            done()

describe 'plugins', ->
    it 'should load a valid plugin', (done) ->
        plugin =
            setup: (defaults) ->
                defaults.foo = 'bar'

        nesh = require '../lib/nesh'

        nesh.loadPlugin plugin, (err) ->
            nesh.plugins.pop()
            assert.equal false, err?
            done()

    it 'should return an error on plugin setup error', (done) ->
        plugin =
            setup: (defaults) ->
                throw new Error('Fake error!')

        nesh = require '../lib/nesh'

        nesh.loadPlugin plugin, (err) ->
            nesh.plugins.pop()
            assert.equal true, err?
            done()
