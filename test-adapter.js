'use strict'

/*
 *  .define-spec
 *  removes the need to search for source code with '../../app/lib...'
 *  define-spec(__filename) will look up the equivalent source file
 *  define-spec 'spec/app/lib/common/async' -> require 'build/app/lib/common/async'
 */
var path    = require('path')
  , join    = path.join
  , resolve = path.resolve;

global.defineSpec = function (loc) {
    var spec = loc
        .replace(join(__dirname, '/specs/'), '')
        .replace(/\.(ls|js)$/ig, '');

    var dest = resolve(join('./build', spec));
    return require(dest);
};

