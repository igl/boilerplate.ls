'use strict'

var fs        = require('fs');
var spawn     = require('child_process').spawn
var pathJoin  = require('path').join;

/**
 * simple watch script make-task
 * make-watch.js [files...]
 *
 * polls every 333ms for changes
 * fs.watch is unstable and uneven across platform
 * files might be called multible times with the same event
 * or calls 'change' instead of 'delete/remove' events
 *
 * todo:
 * scripts forks itself wihout stdin
 */

// Init script with process.argv
// Create a cache for watch replies that is emtpied every 250ms
var cache = [];
var listeners = {};
var makeBaseDir = __dirname;
var argv = getArgv()
var buildCmd = 'build'

if (argv.length > 0) {

    if (getParam(argv, '--test')) {
        buildCmd = 'test'
    }

    argv.forEach(function (dir) {
        if (dir[0] === '-') return;
        watchDir(dir);
        console.log('watching %s', dir);
    });
    nextTick(); // start polling for changes
} else {
    // and print some messages
    console.error('no input. give [file|dir]');
    return process.exit(1);
}

spawn('node', [ '.' ], {
    cwd: makeBaseDir,
    stdio: 'inherit' // inherit or ignore
});

// ----------------------------------------------------------------------------
//
// lib
//
//
// dirExists :: string -> bool
function dirExists (d) {
    return fs.existsSync(d) && fs.statSync(d).isDirectory();
}

function has (a, v) {
    return a.indexOf(v) > -1
}
function getParam (a, v) {
    var idx = a.indexOf(v);
    if (idx === -1) return false;
    a.splice(idx, 1);
    return true;
}

//
// getArgv :: void -> array
// Read argv and filter out duplicates
// and save --paramter and directories only
function getArgv () {
    return (process.argv
        .slice(2)
        .map(function (s) { return (s[0] === '-' ? s : pathJoin(makeBaseDir, s)); })
        .filter(function (s) { return (s[0] === '-' || dirExists(s));  }));
}

//
// watchDir :: string -> void
// Watch a folder
// create a closure for each dir
// cache all events
function watchDir (dir) {
    var tick = function tick (ev, file) {
        if (file) {
            file = pathJoin(dir, file);
            if (has(cache, file)) {
                cache.push(file);
            }
        } else {
            cache.push(dir);
        }
    }

    if (!listeners[dir]) {
        listeners[dir] = [];
    }

    fs.watch(dir, tick);
    listeners[dir].push(tick);
}

//
// nextTick :: void -> object
// check on cache every 333ms
// Pass items to onTick and remove all items from cache
// don't tick while `make build` it running
function nextTick () {
    return setTimeout(function () {
        if (cache.length === 0) return nextTick();  // wait for next tick
        // call change
        onChange(cache.slice(0));
        cache.length = 0;
    }, 333);
}

//
// Build changes
// make clean build when files were removed
// onChange :: array -> void
function onChange (tasks) {
    var make;
    var makeProcess = {
        cwd: makeBaseDir,
        timeout: (1000 * 120),
        stdio: 'inherit' // inherit or ignore
    };

    var hasRemovedFiles = tasks.every(function (t) { return fs.existsSync(t); });

    if (hasRemovedFiles) {
        make = spawn('make', [ buildCmd ], makeProcess);
    } else {
        make = spawn('make', [ 'clean', buildCmd ], makeProcess);
    }

    make.on('close', function (code, signal) {
        if (code !== 0) {
            console.error('make terminated(%d)', code, signal);
        }
        nextTick();
    });
}

process.on('uncaughtException', function (err) {
    console.error("\n! UncaughtException\n> %s\n> %s\n...", err.message, err.stack);
    process.exit(1);
});

process.on('SIGINT', function() {
    process.exit(0);
});
