require "compensated/event_parser"
module Compensated
  module AppleIap
    class EventParser < Compensated::EventParser
      SUPPORTED_TYPES = ["INTERACTIVE_RENEWAL", "DID_CHANGE_RENEWAL_STATUS"]
      def parses?(request)
        return false unless request.data
        request.data[:notification_type] &&
          SUPPORTED_TYPES.include?(request.data[:notification_type])
      end

      def normalize(data)
        data = Compensated.json_adapter.parse(data) unless data.respond_to?(:key)
        {
          raw_body: Compensated.json_adapter.dump(data),
          raw_event_type: data[:notification_type].to_sym,
          raw_event_id: receipt_data(data)[:transaction_id],
          payment_processor: :apple_iap,
          customer: customer(data),
          products: products(data),
          timestamp: DateTime.parse(receipt_data(data)[:purchase_date]),
        }.compact
      end

      def receipt_data(data)
        data[:latest_expired_receipt_info] || data[:latest_receipt_info]
      end

      def products(data)
        [
          {sku: receipt_data(data)[:product_id]},
        ]
      end

      def customer(data)
        {
          id: receipt_data(data)[:original_transaction_id],
        }
      end
    end
  end
  event_parsers.push(AppleIap::EventParser.new)
end
