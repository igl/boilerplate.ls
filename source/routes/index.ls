'use strict'

require! {
    'express'
    '../api' .http
}

# add static directories
# load compiled assets over static assets.
http.use express.static './build/static/'
http.use express.static './static'

http.get '/' (req, res) ->
    res.render 'index'

# http.use(errorHandler);
# http.use(notFoundHandler);
