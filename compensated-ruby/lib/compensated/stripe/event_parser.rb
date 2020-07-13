require 'compensated/event_parser'
module Compensated
  module Stripe
    SUPPORTED_EVENTS = %w[charge.succeeded invoice.payment_succeeded invoice.payment_failed
                          customer.subscription.updated customer.subscription.deleted].freeze
    class EventParser < Compensated::EventParser
      def parses?(request)
        return false if request.nil? || request.empty?

        SUPPORTED_EVENTS.include?(request.data[:type])
      end

      # Transform Stripe input data into Compensated event hash
      #
      # @param input [String, IO, Rack::Request]
      # @return [Hash]
      def transform(data)
        data = extract(data)
        {
          raw_body: Compensated.json_adapter.dump(data),
          raw_event_type: data[:type].to_sym,
          raw_event_id: data[:id],
          payment_processor: :stripe,
          amount: amount(data),
          customer: customer(data),
          invoice: invoice(data),
          products: products(data),
          timestamp: Time.at(data[:created])
        }
      end

      def extract(data)
        data.respond_to?(:key) ? data : Compensated.json_adapter.parse(data)
      end

      private def invoice(data)
        return nil unless invoice?(data)

        {
          id: data[:data][:object][:id],
          created: Time.at(data[:data][:object][:created])
        }
      end
      private def customer(data)
        if invoice?(data)
          {
            email: data[:data][:object][:customer_email],
            name: data[:data][:object][:customer_name],
            id: data[:data][:object][:customer]
          }.compact
        else
          {
            id: data[:data][:object][:customer]
          }
        end
      end

      private def products(data)
        key = (invoice?(data) ? :lines : :items)
        return [] unless data[:data][:object][key]

        items = data[:data][:object][key][:data]

        items.map do |line|
          value = product(line, data)
          next if value.nil? || value.empty?

          value
        end
      end

      private def product(line, data)
        return nil if line.nil? || line.empty?

        {
          sku: sku(line),
          purchased: purchased(data),
          description: line[:description],
          quantity: line[:quantity],
          # TODO: Deprecate `expiration` as it now lives on subscription!
          #       BUT people are using `expiration` so let's figure out
          #       a way to safely remove it.
          expiration: period_end(line, data),
          subscription: subscription(line, data),
          plan: plan(line)
        }.compact
      end

      private def period_start(line, data)
        return nil unless line[:period] || data[:data][:object][:current_period_start]

        timestamp = line[:period] ? line[:period][:start] : data[:data][:object][:current_period_start]
        Time.at(timestamp)
      end
      private def period_end(line, data)
        return nil unless line[:period] || data[:data][:object][:current_period_end]

        timestamp = line[:period] ? line[:period][:end] : data[:data][:object][:current_period_end]
        Time.at(timestamp)
      end

      private def subscription(line, data)
        {
          id: line[:subscription],
          period: {
            start: period_start(line, data),
            end: period_end(line, data)
          }.compact,
          status: subscription_status(data)
        }.compact
      end

      private def subscription_status(data)
        return :ended unless data[:data][:object][:ended_at].nil?
        return :canceled unless data[:data][:object][:canceled_at].nil?
        return :active if data[:data][:object][:status] == 'paid'

        data[:data][:object][:status].to_sym
      end

      private def plan(line)
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
        string = data[:data][:object][:created] || data[:data][:object][:status_transitions][0][:paid_at]
        return nil if string.nil?

        Time.at(string)
      end

      private def amount(data)
        {
          currency: data[:data][:object][:currency]&.upcase,
          due: due(data),
          paid: paid(data),
          remaining: remaining(data)
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
        data[:data][:object][:object] == 'invoice'
      end
    end
  end

  # Ensure Compensated is aware that the stripe event parser is available.
  event_parsers.push(Stripe::EventParser.new)
end
