'use strict'

require! {
    'optionator'
}

# test .parse behavior of optionator

parse = (argv = (process.argv)) ->
    console.log argv

    options = optionator do
        prepend: 'Usage: [options]'
        append: 'Version 1.0.0'
        options:
          * option: 'help'
            alias: '?'
            type: 'Boolean'
            default: false

          * option: 'port'
            alias: 'p'
            type: 'Int'
            default: '3000'
            example: '--port 3000'

          * option: 'host'
            alias: 'h'
            type: 'String'
            default: '0.0.0.0'
            example: '--host 127.168.0.1'

    options.parse argv

console.log parse!
