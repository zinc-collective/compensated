require "compensated/proxy/version"

require 'net/http'

require 'compensated'



module Compensated
  class Proxy
    class Error < StandardError; end

      attr_accessor :to, :http_client
      def initialize(to: , http_client: Net::HTTP)
        self.http_client = http_client
        self.to = URI(to)
      end

      def handle(request)
        handler = Compensated::PaymentProcessorEventRequestHandler.new(request)
        data = handler.normalized_event_data
        data.delete(:raw_body)
        forward(JSON.dump(data))
      end

      private def forward(data)
        http_client.post(to, data, "Content-Type" => "application/json")
      end
  end
end
