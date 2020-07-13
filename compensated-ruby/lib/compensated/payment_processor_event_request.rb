require 'forwardable'
module Compensated
  # Decorator for the Rack::Request to provide Compensated specific
  # functionality
  class PaymentProcessorEventRequest
    extend Forwardable

    attr_accessor :request
    # @param request [Rack::Request] A rack-compatible HTTP request triggered
    #                                by the payment processor
    def initialize(request)
      self.request = request
    end

    def_delegator :request, :form_data?
    def_delegator :request, :body

    # @returns Hash
    def data
      return @data if defined?(@data) && !@data.nil?

      if request.form_data?
        @data = request.params
      elsif !body.nil?
        @data = Compensated.json_adapter.parse(body)
      end
    end

    def empty?
      body.nil? || body.respond_to?(:empty?) && body.empty?
    end
  end
end
