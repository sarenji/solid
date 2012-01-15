# solid

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

* Add HTTP tests
* Asynchronous request handlers (reading file, etc.)