/*
 *  async
 *
 *  .chain
 *  .series
 *  .delay
 *  .interval
 *
 *  async.chain do
 *     (done) !->
 *         do-stuff -> done err, num
 *     (num, done) !->
 *         do-stuff -> done err, result
 *     (err, result) !->
 *         console.log err, result
 */
'use strict'

# chain :: ...function -> function -> void
# chain :: ...(...any? -> function) -> (err -> ...any) -> void
export chain = (...fns, cb) !->
    link = (e, ...args) !->
        if e or (not fns.length) then (cb ... &)
        else try fns.shift! ... (args ++ link)
        catch => cb e

    try fns.shift! link    # init chain
    catch => cb e          # catch first possible error outside of callback

# series :: ...function -> function -> void
# series :: ...(...any? -> function) -> (...any[any[]]) -> void
# call a series of function and wait for the last callback
export series = (...fns, cb) !->
    ticks = fns.length
    resp  = Array ticks

    fns.forEach (f, i) ->
        try f (...args) !->
            resp[i] = [] ++ args
            if --ticks is 0 then (cb ... &)
        catch
            resp[i] = [] ++ e

# delay :: number -> function -> object
export delay = (msec, f) -->
    i = 0
    iv = setInterval do
        !-> (clearInterval iv) if (f i++) isnt false
        msec

# interval :: number -> function -> object
export interval = (msec, f) -->
    i = 0
    iv = setInterval do
        !-> (clearInterval iv) if (f i++) is false
        msec
