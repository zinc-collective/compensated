require_relative "stripe/version"
require_relative "stripe/event_parser"

module Compensated
  module Stripe
    class Error < Compensated::Error; end
  end
end
