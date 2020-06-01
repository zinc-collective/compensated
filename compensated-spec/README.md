# Compensated::Spec

Programattically test your implementation of the [Compensated] payment adapter library with event fixtures and such.

[Compensated]: https://www.zinc.coop/compensated

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compensated-spec'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install compensated-spec

## Usage
`Compensated::Spec` is primarily used to generate event fixtures for the payment processors we support and run them through your payment event handling pipeline. These fixtures can either be generated  with the `compensated-spec` command line program, or integrated directly into your testing code, so long as the code is written in Ruby.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zinc-collective/compensated. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct].

For more information, see the [Contributing Guide].

[Contributing Guide]:../CONTRIBUTING.md

## Code of Conduct

Everyone interacting in the `Compensated::Spec` project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct].

[code of conduct]: https://www.zinc.coop/code-of-conduct