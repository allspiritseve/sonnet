# Sonnet

JSON logging for Ruby applications.

## Philosophy

* Adhere to Ruby conventions as much as possible. Keep API as close as possible
  to
  [Logger](https://ruby-doc.org/stdlib-2.6.2/libdoc/logger/rdoc/Logger.html).
  If Sonnet were removed, your log lines should continue to work (though they
  might be ugly).
* Configurable, to a point
* For advanced use cases, see below alternatives.
* Work as well for Ruby application as for Rails

## Alternatives

* [Ougai](https://github.com/tilfin/ougai)
* [Semantic Logger](https://github.com/rocketjob/semantic_logger)
* Custom log formatter (seriously, it's really easy!)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sonnet'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sonnet

## Usage

```ruby
require "sonnet"
logger = Logger.new(STDOUT)
logger.extend(Sonnet::Logger)
```

## Ruby on Rails

It shouldn't be as much of a pain as it is to configure Rails to log JSON. Even
if you're able to do it, every gem introduces another logger that might have to
be configured.

### ActiveSupport::TaggedLogger

The easiest workaround is to just not use it. However, Rails uses it
internally, and _it modifies the logger passed to it_! So you (currently) can't
escape monkeypatching Rails.

Additionally, it is useful to be able to specify context info that gets logged
with every line inside of a block. I have plans to possibly support `#tagged`,
but I'm not sure what a sensible default is for converting string tags into a
hash. Some options:
* store in a `tags` array
* attempt to guess at keys for each tag (possble if passing symbols to
  `log_tags`, but probably can't handle every use case).
* Allow user to define keys for each tag

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/allspiritseve/sonnet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
