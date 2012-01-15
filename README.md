# solid

[![Build Status](https://secure.travis-ci.org/sarenji/solid.png)](http://travis-ci.org/sarenji/solid)

shape super-small, simple, solid sites.

## Installation

```bash
$ npm install solid
```

## Hello world example:

```coffeescript
require('solid') ->
  "/" : "<b>Hello world!</b>"
```

That's it. No, really.

A bit more contrived example can be found [here](https://github.com/sarenji/solid/blob/master/examples/hello_world.coffee), where you can see everything you can do in solid currently.

## Running tests

```bash
$ npm test
```

This will run solid's `mocha` tests.

## Contributors

[Abi Raja](https://github.com/abi) for the idea and contributions.

## TODO

* Asynchronous request handlers (reading file, etc.)
* Logging with noise levels (should be low-priority, basic method/path console logging already exists)
* Override the HTTP response header X-Powered-By to Solid from Express :)