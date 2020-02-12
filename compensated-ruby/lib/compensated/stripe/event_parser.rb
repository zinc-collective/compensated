require "compensated/event_parser"
module Compensated
  module Stripe
    SUPPORTED_EVENTS = %w[charge.succeeded invoice.payment_succeeded invoice.payment_failed customer.subscription.deleted]
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
          products: products(data),
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

      private def products(data)
        if invoice?(data)
          data[:data][:object][:lines][:data].map do |line|
            value = product(line, data)
            next if value.nil? || value.empty?
            value
          end
        end
      end

      private def product(line, data)
        return nil if line.nil? || line.empty?
        {
          sku: sku(line),
          purchased: purchased(data),
          description: line[:description],
          quantity: line[:quantity],
          expiration: Time.at(line[:period][:end]),
          plan: plan(line, data)
        }.compact
      end

      private def plan(line, data)
        return nil unless line[:plan] && line[:plan].respond_to?(:[])
        {
          sku: line[:plan][:id],
          name: line[:plan][:nickname],
          interval: {
            period: line[:plan][:interval],
            count: line[:plan][:interval_count]
          }.compact
        }.compact
      end

      private def sku(line)
        plan = line.fetch(:plan, {})
        return nil if plan.nil?
        plan.fetch(:product, nil)
      end

      private def purchased(data)
        string = data[:data][:object][:status_transitions][:paid_at]
        return nil if string.nil?
        Time.at(string)
      end

      private def amount(data)
        {
          currency: data[:data][:object][:currency]&.upcase,
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
