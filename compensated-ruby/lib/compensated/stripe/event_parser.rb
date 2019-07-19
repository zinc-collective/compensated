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
          amount: amount(request),
        }
      end

      private def amount(request)
        {
          currency: request.data[:data][:object][:currency].upcase,
          due: due(request),
          paid: paid(request),
          remaining: remaining(request),
        }.compact
      end

      private def paid(request)
        return request.data[:data][:object][:amount_paid] if invoice?(request)
        request.data[:data][:object][:amount]
      end

      private def remaining(request)
        request.data.fetch(:data, {}).fetch(:object, {}).fetch(:amount_remaining, nil)
      end

      private def due(request)
        request.data.fetch(:data, {}).fetch(:object, {}).fetch(:amount_due, nil)
      end

      private def invoice?(request)
        request.data[:data][:object][:object] == "invoice"
      end
    end
  end

  # Ensure Compensated is aware that the stripe event parser is available.
  event_parsers.push(Stripe::EventParser.new)
end
