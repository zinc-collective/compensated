# frozen_string_literal: true

require_relative 'proxy/version'

require 'net/http'

require 'compensated'

module Compensated
  class Proxy
    # Parent class for Proxy errors.
    class Error < StandardError; end

    attr_accessor :forward_to, :http_client

    # @param [String, URI] forward_to Downstream event handler that accepts formatted payment events
    # @param [#post] http_client Object  HTTP transport. Defaults to the `Net::HTTP` constant.
    def initialize(forward_to:, http_client: Net::HTTP)
      self.http_client = http_client
      self.forward_to = URI(forward_to)
    end

    def call(env)
      request = Rack::Request.new(env)
      handle(request)
      res = Rack::Response.new
      res.finish
    end

    # Accepts an HTTP request and forwards it to the downstream event handler
    # @param [Rack::Request] request Inbound HTTP request with a Payment Gateways'
    #                                event payload
    def handle(request)
      handler = Compensated::PaymentProcessorEventRequestHandler.new(request)
      data = handler.normalized_event_data
      data.delete(:raw_body)
      forward(JSON.dump(data))
    end

    private def forward(data)
      http_client.post(forward_to, data, 'Content-Type' => 'application/json')
    end
  end
end
