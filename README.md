# solid [![Build Status](https://secure.travis-ci.org/sarenji/solid.png?branch=master)](http://travis-ci.org/sarenji/solid)

make small, simple sites.

## Installation

```bash
$ npm install solid
```

## Hello world example:

```coffeescript
require('solid') ->
  @get "/", -> "<b>Hello world!</b>"
```

That's it. No, really.

A bit more contrived example can be found [here](https://github.com/sarenji/solid/blob/master/examples/simple.coffee), where you can see some of what you can do in solid currently.

## Running tests

```bash
$ npm test
```

This will run solid's `mocha` tests.

## Contributors

[Abi Raja](https://github.com/abi) for the idea and contributions.

## TODO

(Ordered roughly in terms of priority)

* Asynchronous request handlers (reading file, etc.)
* CSS Reset
* Other commonly used JS libraries other than jQuery
* Logging with noise levels (should be low-priority, basic method/path console logging already exists)
* Better 404 page (low priority)
