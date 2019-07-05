module Compensated
  # Normalizes events by wrapping them in the appropriate
  # payment processor event class
  class PaymentProcessorEventRequestHandler
    attr_accessor :event_request
    # @param event_request [Request] A rack-compatible HTTP request triggered
    #                                by the payment processor
    def initialize(event_request)
      self.event_request = event_request
    end

    # @return Hash
    def normalized_event_data
      event_parser.parse(event_request_body_json)
    end

    protected def event_parser
      return @event_parser unless @event_parser.nil?
      @event_parser = event_parsers.find { |parser| parser.parses?(event_request_body_json) }
      raise NoParserForEventError, event_request_body if @event_parser.nil?
      @event_parser
    end

    protected def event_parsers
      Compensated.event_parsers
    end

    protected def event_request_body_json
      @event_request_body_json ||= Compensated.json_adapter.parse(event_request_body)
    end

    protected def event_request_body
      return @event_request_body unless @event_request_body.nil?
      @event_request_body = event_request.body
    end
  end
end