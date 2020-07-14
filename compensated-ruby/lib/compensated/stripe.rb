# frozen_string_literal: true

require_relative 'stripe/version'
require_relative 'stripe/event_parser'
require_relative 'stripe/apply_command'

module Compensated
  module Stripe
    class Error < Compensated::Error; end
  end
end
