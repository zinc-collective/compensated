# Compensated::Proxy

A forwarding proxy for the [Compensated] payment adapter library, so you can use it
without needing to switch your project to Ruby!

[Compensated]: https://www.zinc.coop/compensated

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compensated-proxy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install compensated-proxy

## Usage
The Compensated::Proxy is primarily used as a command line program that
verifies the signature of inbound payment processor events, reformats the
events into the standardized Compensated event format, signs them, and
forwards them on to your event listener endpoint.

`$ compensated-proxy --forward-to https://example.com/your-event-listener`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zinc-collective/compensated. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct].

For more information, see the [Contributing Guide].

[Contributing Guide]:../CONTRIBUTING.md

## Code of Conduct

Everyone interacting in the Compensated::Proxy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct].

[code of conduct]: https://www.zinc.coop/code-of-conduct