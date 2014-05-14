'use strict'
/*
 *  controller
 *
 *  .express
 */

require! {
    'http'
    'express'
    'redis'
    'child_process'
}

export get-router = ->
    app = express!

    # monkey patch express.listen()
    app.listen = (f) !->
        http-server = http.createServer app
            .listen (app.get 'port'), (app.get 'host'), f

        http-server.on 'error', ({ message, stack }) !->
            console.error do
                "\n! ServerError in %j %s:%s\n>>> #message\n#stack\n<<< ..."
                process.title
                app.get 'host'
                app.get 'port'
            console.trace err
        app.set 'listening' true

    return app

export get-redis = (host, port, user, pass, cb) ->
    client = (require 'redis')createClient port, host
    client.auth pass
    process.once 'exit', -> client.end!
    client.once 'ready', -> cb null, client
    return client
