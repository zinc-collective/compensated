module Compensated
  module Gumroad
    class EventParser
      def parses?(request)
        # Gumroad pings are always form data
        return false unless request.form_data?
        keys = request.data.keys.map(&:to_sym)
        keys.include?(:seller_id) && keys.include?(:product_id) && keys.include?(:product_permalink) && request.data["product_permalink"].include?("gum.co")
      end

      def parse(request)
        {
          raw_body: request.body,
          raw_event_type: request.data["resource_name"].to_sym,
          raw_event_id: nil,
          payment_processor: :gumroad,

        }
      end
    end
    Compensated.event_parsers.push(EventParser)
  end
end
