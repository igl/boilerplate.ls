# LiveScript console script
# implements a silent mkdir -p alternative for windows
require! [
    'mkdirp'
    'path'.resolve
    'prelude-ls'
]

global <<< prelude-ls

# dirs = mapped argv[] to path.resolve()
# call mkdirp()
process.argv |> drop 2 |> each ->
    mkdirp (resolve it), (err) ->
        if err then
            console.error 'mkdirp-win error: %j' err.message;
