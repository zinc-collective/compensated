# Developer Documentation for Compensated

Compensated intends to make it safe and easy for people to begin taking payments
from their customers directly within their application from a variety of payment
sources. Compensated is packaged and distributed as a Ruby library ([source
code][compensated-ruby-source]) that acts as an [adapter][adapter-pattern]
between your application code and payment processors or stores such as
[Stripe][stripe] ([source][compensated-ruby-stripe-source]), [Apple In-App
Purchases][apple-iap] ([source][compensated-ruby-apple-iap-source]), or
[Gumroad][gumroad] ([source][compensated-ruby-gumroad-source]).

The adapters primary purpose is to transfrom the data sent to your application
from each payment processors particular data structures into a single data
structure that looks something like this:

```ruby
{
  # The data as provided by the payment processor in a pure string format
  "raw_body": "...",
  # Each payment processor tells us what kind of type
  "raw_event_type": "...",
  # We have made some best guesses about what fields to use for a unique id for the event. Some payment processors provide this, others don't.
  "raw_event_id": "...",
  # What payment processor the event was from
  "payment_processor":"stripe",
  # When an event has payment or invoiced amounts available,
  # we show that here.
  #
  # All amounts are in whole units (cents, for example).
  "amount": {
    # The currency the amounts are in
    "currency":"USD",
      # The amount paid in this particular event.
     "paid":400,
     # The amount due before this particular event.
     "due": 400,
     # The final balance remaining, assuming there is one.
     "remaining": 0
    }
  },
  # Some payment processors provide "customer" data that allows you
  # to know which particular customer in their system the transaction
  # relates to.
  "customer": {
    # The payment processors internal customer id
    "id": "...",
    # Some payment processors also provide contact information.
    "email": "...",
    # Including names.
    "name": "..."
  },
  # "invoices" is only provided for payment processors that support
  # invoicing.
  "invoice": {
    # The payment processors internal ID for the invoice
    "id": "...",
    # A `Time` object representing when the invoice was created
    "created": Time.now,
  },
  # Some events also include product information, such as SKUs.
  "products": [
    {
      # String representation of the salable unit per the payment
      # processors records
      "sku": "...",
      # Time of purchase, according to payment processor when available.
      "purchased": Time.now,
      # String of the payment processors description of the product
      "description": "...",
      # I _believe_ this is an integer, but we're not enforcing it.
      "quantity": 1
      # If the product is for a subscription, include the expiration
      # timestamp.
      #
      # That said, it probably should live in the subscription object...
      "expiration" Time.now,
      # If the product is for a subscription, and we have more data about
      # the particular subscription, we give a more detailed object
      #
      # Subscriptions are the union between a plan and a customer.
      # Now that I look at it, I'm not sure why it's in the products
      # array?
      "subscription": {
        # This is the payment processors internal representation of the
        # subscription ID. Some payment processors do not have this.
        "id": "..."
      },
      # A 'plan' is often shared between customers, and specifies things
      # like payment schedule, name, sku for accounting purposes, etc.
      "plan": {
        "sku": "...",
        "name": "...",
        "interval": {
          # On what basis is the plan invoiced (day? week? month?
          # year?)
          "period": "",
          # How many periods between invoices?
          "count": "",
        }
      }
    }
    , # Additional products as necessary
  ]
  # Time object of the event timestamp provided by the payment processor
  "timestamp":"2019-09-20 02:00:47 -0700"}
}
```

We want to improve the data structure going forward; and will indicate field deprecations. In `0.X` we will deprecate fields on odd numbers, and remove them on even ones.

[adapter-pattern]: https://en.wikipedia.org/wiki/Adapter_pattern
[stripe]: https://www.stripe.com
[apple-iap]: https://developer.apple.com/documentation/storekit/in-app_purchase
[gumroad]: https://gumroad.com/
[compensated-ruby-stripe-source]:
  https://github.com/zinc-collective/compensated/tree/0.X/compensated-ruby/lib/compensated/stripe
[compensated-ruby-apple-iap-source]:
  https://github.com/zinc-collective/compensated/tree/0.X/compensated-ruby/lib/compensated/apple_iap
[compensated-ruby-gumroad-source]:
  https://github.com/zinc-collective/compensated/tree/0.X/compensated-ruby/lib/compensated/gumroad
[compensated-ruby-source]:
  https://github.com/zinc-collective/compensated/tree/0.X/compensated-ruby
