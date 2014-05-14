'use strict'

require! {
    'expect.js'
}

suite 'lib/bootstrap' !->

    bootstrap = define-spec __filename

    suite 'is-test' !->
        test 'is in test-env' !->
            expect(bootstrap.is-test).to.be.a 'boolean'
        test 'we are testing so it should be true' !->
            expect(bootstrap.is-test).to.be true

    suite 'pkg' !->
        test 'is loading package.json' !->
            expect(bootstrap.pkg).to.be.a 'object'
            expect(bootstrap.pkg.name).to.be.a 'string'
            expect(bootstrap.pkg.version).to.be.a 'string'
            expect(bootstrap.pkg.dependencies).to.be.a 'object'

    suite 'get-env' !->
        test 'is valid NODE_ENV string' !->
            env = bootstrap.get-env!
            expect(env).to.be.a 'string'
            expect(env == \development or env == \production).to.be true

    suite 'get-argv' !->
        test 'is a function' !->
            expect(bootstrap.get-argv).to.be.a 'function'

        test 'parse parameter' !->
            argv = bootstrap.get-argv <[ node fuck --host 127.168.0.1 --port 1337 ]>

            expect(argv.host).to.be.a 'string'
            expect(argv.host).to.be '127.168.0.1'
            expect(argv.port).to.be.a 'number'
            expect(argv.port).to.be 1337

        test 'parse parameter alias' !->
            argv = bootstrap.get-argv <[ node fuck -H 127.168.0.1 -P 1337 ]>

            expect(argv.host).to.be.a 'string'
            expect(argv.host).to.be '127.168.0.1'
            expect(argv.port).to.be.a 'number'
            expect(argv.port).to.be 1337
