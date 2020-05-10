require "compensated/proxy/version"

require 'net/http'

require 'compensated'



module Compensated
  class Proxy
    class Error < StandardError; end

      attr_accessor :forwarder
      def initialize(forwarder: )
        self.forwarder = forwarder
      end

      def handle(request)
        handler = Compensated::PaymentProcessorEventRequestHandler.new(request)
        data = handler.normalized_event_data
        data.delete(:raw_body)
        forwarder.forward(JSON.dump(data))
      end

    class Forwarder
      attr_accessor :http_client, :to
      def initialize(to:, http_client:)
        self.http_client = http_client
        self.to = to
      end

      def forward(data)
        http_client.post(URI(to), data, "Content-Type" => "application/json")
      end
    end
  end
end
