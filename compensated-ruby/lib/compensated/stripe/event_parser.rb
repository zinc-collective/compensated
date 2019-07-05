module Compensated
  module Stripe
    SUPPORTED_EVENTS = %w[charge.succeeded invoice.payment_succeeded]
    class EventParser
      def parses?(input_event)
        return false if input_event.nil? || !input_event.respond_to?(:key)
        SUPPORTED_EVENTS.include?(input_event[:type])
      end

      def parse(input_event)
        {
          raw_body: Compensated.json_adapter.dump(input_event),
          raw_event_type: input_event[:type].to_sym,
          raw_event_id: input_event[:id],
          payment_processor: :stripe,
        }
      end
    end
  end

  event_parsers.push(Stripe::EventParser.new) # Adds to the event parses available to compensated
end
