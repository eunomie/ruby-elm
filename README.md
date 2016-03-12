ruby-elm
========

[![Build Status](https://travis-ci.org/eunomie/ruby-elm.svg?branch=master)](https://travis-ci.org/eunomie/ruby-elm) [![Gem Version](https://badge.fury.io/rb/ruby-elm.svg)](https://badge.fury
.io/rb/ruby-elm)

Ruby wrapper over [elm](http://elm-lang.org).

Allow to compile elm files using ruby.

Installation
------------

### Prerequisites

- Tested against Ruby 2.3
- `elm make` installed and available in `$PATH`

### Setup

```
gem install ruby-elm
```

Usage
-----

### Library

```ruby
require 'elm'

# Compile files to a string
Elm.compiler.files(['test.elm']).to_s

# Compile files to a file
# index.html
Elm.compiler.files(['test.elm']).to_file
# other output
Elm.compiler.files(['test.elm'],
  with_options: { output: 'out.js' }).to_file

# Compile content to a string or file
content = <<EOF
import Html exposing (text)

main =
  text "Hello, World!"

EOF
Elm.compiler.content(content).to_s
Elm.compiler.content(content).to_file
```

Some options are available:

- `output`: `String`
- `yes`: `Bool`
- `report`: `:normal`/`:json`
- `warn`: `Bool`
- `docs`: `String`

When compile using `Elm.compiler`, `yes` is always forced as the ruby wrapper is not interactive.

### Executable

The executable works as `elm-make`:

```sh
ruby-elm-make test.elm --warn --output out.js
```

`yes` is always forced as the wrapper is not interactive.

ToDo
----

Force json mode and extract warnings and errors to ruby objects.

Contributing
------------

1. [Fork it](https://github.com/eunomie/ruby-elm/fork)
1. Install dependencies (`bundle install`)
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write and run tests (`rspec`)
1. Commit your changes (`git commit -am 'Add some feature`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new _Pull Request_

LICENSE
-------

Please see [LICENSE][].

AUTHOR
------

Yves Brissaud, [@\_crev_](https://twitter.com/_crev_), [@eunomie](https://github.com/eunomie)

[LICENSE]: https://github.com/eunomie/ruby-elm/blob/master/LICENSE
