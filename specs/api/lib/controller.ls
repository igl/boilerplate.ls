'use strict'

require! {
    'expect.js'
}

suite 'lib/controller' !->

    controller = define-spec __filename

    suite '.router' !->
        test 'returns a express router' !->
            expect(controller.get-router).to.be.a 'function'
            expect(controller.get-router!).to.be.a 'function'
