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
          customer: customer(request),
        }
      end

      private def customer(request)
        if invoice?(request)
          {
            email: request.data[:data][:object][:customer_email],
            name: request.data[:data][:object][:customer_name],
            id: request.data[:data][:object][:customer],
          }.compact
        else
          {
            id: request.data[:data][:object][:customer],
          }
        end
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
