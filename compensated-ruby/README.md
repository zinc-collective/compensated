# Compensated

Compensated makes it easy to adjust your customer experience based upon whether or not someone has paaaaiiiiiiiid.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compensated'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compensated

## Usage

Right now, we do not provide a Rack plugin or Rails engine for use with Compensated; this is because we don't really know what the best interface is. Part of our goal for 1.0 is a very boring set of defaults, but we don't want to codify that yet.


### Rails Example
```rb
class PaymentProcessorEventsController < ApplicationController
  def create
    # We provide a basic request handler that transform the payment processor event data
    # for your convenience.
    handler = Compensated::PaymentProcessorEventRequestHandler.new(request)


    # If you use ActiveRecord, we provide a model for persisting the
    # events in your database.

    # We strongly encourage keeping payment processor events around
    # for conflict reconciliation, fraud detection, etc.
    event = Compensated::PaymentProcessorEvent.create(handler.normalized_event_data)
    if event.persisted?
      head :ok
    else
      # Some payment processors will retry sending of the event
      # if you tell them things didn't work out right.

      # We encourage you to return a 5XX status code to trigger
      # the retry behavior.
      head :internal_server_error
    end
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zinc-collective/compensated. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Compensated project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/zinc-collective/compensated/blob/primary/CODE_OF_CONDUCT.md).
