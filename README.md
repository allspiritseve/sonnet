# Sonnet

Structured logging for Ruby applications.

## Alternatives

* [Ougai](https://github.com/tilfin/ougai)
* [Semantic Logger](https://github.com/rocketjob/semantic_logger)

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/allspiritseve/sonnet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
