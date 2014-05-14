* boilerplate.ls
---
Written
- in <strike>JavaScript</strike> [Livescript](http://livescript.net/)
- for: [node.js](http://nodejs.org/)
- using: [express 4](http://expressjs.com/)
[jade](http://jade-lang.com)
[stylus](http://learnboost.github.io/stylus/)
[less](http://lesscss.org/)

---

### First run:

    node . [options]

defaults to: package.json.main: /build/api/index.js
<br>
or for development:

    make <install>
          build
          test
          run
          watch
          watchtest

    chainable
    make clean run
    make clean watch


---

### make `[ all install build run test watch watch-test clean ]`

make install
- npm install
- make clean build

make build
- compiles all source files

make run
- make build
- Starts `node` with (package.json).main

make test
- run mocha on all files in ./specs (--recursive)
- mocha uses a LiveScript adapter so no compile step is required

make clean
- removes `./build`
