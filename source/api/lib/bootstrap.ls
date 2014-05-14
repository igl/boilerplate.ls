'use strict'
/*
 *  bootstrap process
 *
 *  .pkg        # package.json
 *  .node-env   # node_env (development or production)
 *  .argv       # parsed process.argv
 *
 */
require! {
    'path'
    'optionator'
    'pkg' : '../../../package.json'
}

# initialize app
# catch uncaughtException
process.on 'uncaughtException' ({ message, stack }) ->
    console.error "\n! UncaughtException\n> #message\n> #stack\n..."
    process.exit 1

process.on 'SIGINT' !->
    console.log '~SIGINT'
    process.exit 0

# set true if modules are loaded by mocha
export is-test = (/mocha$/i .test process.argv.1)

export pkg = require '../../../package.json'

# get valid node-env
export get-env = ->
    env = process.env.NODE_ENV
    dev = \development
    pro = \production
    if (env is pro or env is dev) then env
    else process.env.NODE_ENV = dev;

# parse process.argv
export get-argv = (argv = process.argv) ->
    options = optionator do
        prepend: 'Usage: [options]'
        append: 'Version 1.0.0'
        options:
          * option: 'help'
            alias: 'h'
            type: 'Boolean'
            default: false

          * option: 'port'
            alias: 'P'
            type: 'Int'
            default: '3000'
            example: '--port 8000'

          * option: 'host'
            alias: 'H'
            type: 'String'
            default: '0.0.0.0'
            example: '--host 127.168.0.1'

    # return parsed object
    argv = options.parse argv

    # show help
    if argv.help then
        console.log options.generateHelp!
        process.exit 0;

    argv;
