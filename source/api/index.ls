'use strict'

require! {
    pkg  : './lib/bootstrap'  .pkg
    env  : './lib/bootstrap'  .get-env!
    argv : './lib/bootstrap'  .get-argv!
    http : './lib/controller' .get-router!
}

# export /app module
export pkg
export env
export http
export argv

# configure http router
http.set 'Host'          argv.host
http.set 'port'          argv.port
http.set 'view engine'   'jade'
http.set 'views'         'build/views'
http.set 'listening'     false
http.set 'x-powered-by'  false

# load index route
require '../routes/index'

# start listening
http.listen (err) !->
    if err then throw err
    # print a startup message
    console.log do
        '* http server listening...'
        '\n* started :' (pkg.name or 'UnnamedProject')
        '\n* time    :' new Date!toString!
        '\n* version :' pkg.version or '0.0.0'
        '\n* env     :' env
        '\n* argv    :' argv
