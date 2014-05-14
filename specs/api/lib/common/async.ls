'use strict'

require! {
    'expect.js'
}

suite 'lib/async' !->
    async = define-spec __filename

    suite '.chain()' !->
        test 'passes values' !->
            async.chain do
                (cb) !-> cb null, 'A'
                (a, cb) !-> cb null, a, 'B'
                (a, b, cb) !-> cb null, a, b, 'C'
                (err, a, b, c) !->
                    expect(err).to.not.be.a Error
                    expect(a).to.be 'A'
                    expect(b).to.be 'B'
                    expect(c).to.be 'C'

        test 'breaks at errors', (test-complete) !->
            async.chain do
                (cb) !-> cb null, 'A'
                (a, cb) !-> (cb new Error 'B Failed')
                (a, b, cb) !-> ... # unimplemented
                (err, ...rest) !->
                    expect(err).to.be.a Error
                    test-complete!


    suite '.series()' !->
        test 'returns values', !->
            async.series do
                (cb) !-> cb 'A'
                (cb) !-> cb 'B' 'C'
                (cb) !-> cb 'D'
                ([a], [b, c], [d]) !->
                    expect(a).to.be 'A'
                    expect(b).to.be 'B'
                    expect(c).to.be 'C'
                    expect(d).to.be 'D'


    suite '.delay()' !->
        test 'is curried', !->
            expect(async.delay).to.be.a 'function'
            expect(async.delay 20).to.be.a 'function'
            expect(async.delay(20) ->).to.be.a 'object'

        test 'repeats if callback returns false', (test-complete) !->
            count = 0
            setTimeout do   # complete test after 100ms
                ->
                    expect(count).to.be 3
                    test-complete!
                100;

            async.delay(10) (i) ->
                expect(i).to.be count++
                false if i < 2


    suite '.interval()' !->
        test 'is curried', !->
            expect(async.interval).to.be.a 'function'
            expect(async.interval 20).to.be.a 'function'
            expect(async.interval(20) ->).to.be.a 'object'

        test 'ends if callback returns false', (test-complete) !->
            count = 0
            setTimeout do   # complete test after 100ms
                ->
                    expect(count).to.be 3
                    test-complete!
                100;

            async.interval(10) (i) ->
                expect(i).to.be count
                false if ++count is 3
