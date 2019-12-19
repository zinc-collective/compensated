require "compensated/event_parser"
module Compensated
  module Stripe
    SUPPORTED_EVENTS = %w[charge.succeeded invoice.payment_succeeded invoice.payment_failed]
    class EventParser < Compensated::EventParser
      def parses?(request)
        return false if request.nil? || request.empty?
        SUPPORTED_EVENTS.include?(request.data[:type])
      end

      def normalize(data)
        data = Compensated.json_adapter.parse(data) unless data.respond_to?(:key)
        {
          raw_body: Compensated.json_adapter.dump(data),
          raw_event_type: data[:type].to_sym,
          raw_event_id: data[:id],
          payment_processor: :stripe,
          amount: amount(data),
          customer: customer(data),
          timestamp: Time.at(data[:created]),
        }
      end

      private def customer(data)
        if invoice?(data)
          {
            email: data[:data][:object][:customer_email],
            name: data[:data][:object][:customer_name],
            id: data[:data][:object][:customer],
          }.compact
        else
          {
            id: data[:data][:object][:customer],
          }
        end
      end

      private def amount(data)
        {
          currency: data[:data][:object][:currency].upcase,
          due: due(data),
          paid: paid(data),
          remaining: remaining(data),
        }.compact
      end

      private def paid(data)
        return data[:data][:object][:amount_paid] if invoice?(data)
        data[:data][:object][:amount]
      end

      private def remaining(data)
        data.fetch(:data, {}).fetch(:object, {}).fetch(:amount_remaining, nil)
      end

      private def due(data)
        data.fetch(:data, {}).fetch(:object, {}).fetch(:amount_due, nil)
      end

      private def invoice?(data)
        data[:data][:object][:object] == "invoice"
      end
    end
  end

  # Ensure Compensated is aware that the stripe event parser is available.
  event_parsers.push(Stripe::EventParser.new)
end
