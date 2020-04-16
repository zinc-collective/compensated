require "compensated/event_parser"
module Compensated
  module AppleIap
    class EventParser < Compensated::EventParser
      SUPPORTED_TYPES = ["CANCEL", "DID_CHANGE_RENEWAL_PREF", "DID_FAIL_TO_RENEW", "DID_RECOVER", "INTERACTIVE_RENEWAL", "RENEWAL", "INITIAL_BUY", "DID_CHANGE_RENEWAL_STATUS"]
      def parses?(request)
        return false unless request.data
        request.data[:notification_type] &&
          SUPPORTED_TYPES.include?(request.data[:notification_type])
      end

      def transform(data)
        data = extract(data)
        {
          raw_body: Compensated.json_adapter.dump(data),
          raw_event_type: data[:notification_type].to_sym,
          raw_event_id: receipt_data(data)[:transaction_id],
          payment_processor: :apple_iap,
          customer: customer(data),
          products: products(data),
          timestamp: timestamp(data),
        }.compact
      end

      def extract(data)
        data.respond_to?(:key) ? data : Compensated.json_adapter.parse(data)
      end

      def timestamp(data)
        DateTime.parse(data[:auto_renew_status_change_date] || receipt_data(data)[:purchase_date])
      end

      def receipt_data(data)
        data[:latest_expired_receipt_info] || data[:latest_receipt_info]
      end

      def products(data)
        [
          {
            sku: receipt_data(data)[:product_id],
            purchased: DateTime.parse(receipt_data(data)[:purchase_date]),
            expiration: DateTime.parse(receipt_data(data)[:expires_date_formatted]),
            cancelled: cancellation_date(data),
          }.compact,
        ]
      end

      def customer(data)
        {
          id: receipt_data(data)[:original_transaction_id],
        }
      end

      private

      def cancellation_date(data)
        return unless receipt_data(data)[:cancellation_date]
        DateTime.parse(receipt_data(data)[:cancellation_date])
      end
    end
  end
  event_parsers.push(AppleIap::EventParser.new)
end
