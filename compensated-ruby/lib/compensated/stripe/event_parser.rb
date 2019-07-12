module Compensated
  module Stripe
    SUPPORTED_EVENTS = %w[charge.succeeded invoice.payment_succeeded]
    class EventParser
      def parses?(request)
        return false if request.nil? || request.empty?
        SUPPORTED_EVENTS.include?(request.data[:type])
      end

      def parse(request)
        {
          raw_body: Compensated.json_adapter.dump(request.data),
          raw_event_type: request.data[:type].to_sym,
          raw_event_id: request.data[:id],
          payment_processor: :stripe,
        }
      end
    end
  end

  # Ensure Compensated is aware that the stripe event parser is available.
  event_parsers.push(Stripe::EventParser.new)
end
