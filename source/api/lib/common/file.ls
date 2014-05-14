/*
 *  common/files
 */
'use strict'

require! {
    'fs'
    'path'
    'child_process' .exec
}

# deep-require :: string -> object? -> object
deep-require = (dir, output = {}) ->

    root = path.resolve dir

    parse-dir = (dirloc, out) ->
        fs.readDirSync(dirloc)sort!forEach (name) !->
            loc = path.join dirloc name
            stat = fs.statSync loc

            if stat.isFile! then
                out[name] = name #|> require

            else if stat.isDirectory! then
                out[name] = {};
                parse-dir loc, out[name]
        return out


    unless fs.statSync root .isDirectory! then
        throw Error

    parse-dir root, output;
    return object

export require-all = ->
    loc = path.resolve it
    (exec 'find routes -type f | sort',
        (error, out, err) ->
            console.log 'stdout: ' + out
            console.log 'stderr: ' + err)
