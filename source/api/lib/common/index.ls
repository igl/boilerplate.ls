'use strict'

require! {
    'fs'
}

for file in (fs.readdirSync __dirname)
when 'index' != (file .= replace /\.(js|ls)$/i, '')
then exports[file] = (require '#__dirname/#file')
