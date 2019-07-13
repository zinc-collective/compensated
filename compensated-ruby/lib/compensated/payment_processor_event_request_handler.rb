require_relative "payment_processor_event_request"
module Compensated
  # Normalizes events by passing them to an EventParser
  # Which transforms them into a hash that can be
  # persisted to a database.
  class PaymentProcessorEventRequestHandler
    attr_accessor :event_request
    # @param event_request [Request] A rack-compatible HTTP request triggered
    #                                by the payment processor
    def initialize(event_request)
      @event_parser = nil
      self.event_request = PaymentProcessorEventRequest.new(event_request)
    end

    # @return Hash
    def normalized_event_data
      event_parser.parse(event_request)
    end

    protected def event_parser
      return @event_parser unless @event_parser.nil?
      @event_parser = Compensated.event_parsers.find { |parser| parser.parses?(event_request) }
      raise NoParserForEventError, event_request.data if @event_parser.nil?
      @event_parser
    end
  end
end
