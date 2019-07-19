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
        if request.body.respond_to?(:read)
          body = request.body.read
          request.body.rewind
        else
          body = request.body
        end

        {
          raw_body: body,
          raw_event_type: request.data["resource_name"].to_sym,
          raw_event_id: nil,
          payment_processor: :gumroad,
          amount: {paid: request.data["price"].to_i, currency: request.data["currency"].upcase},
          payer: {id: request.data["purchaser_id"].to_s, email: request.data["email"]},
        }
      end
    end
    Compensated.event_parsers.push(Gumroad::EventParser.new)
  end
end
