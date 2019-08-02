require "webrick"
module Compensated
  module Gumroad
    class EventParser
      def parses?(request)
        # Gumroad pings are always form data
        return false unless request.form_data?
        keys = request.data.keys.map(&:to_sym)
        keys.include?(:seller_id) && keys.include?(:product_id) && keys.include?(:product_permalink) && request.data["product_permalink"].include?("gum.co")
      end

      def normalize(data_or_body)
        data = data_or_body.respond_to?(:key) ? data_or_body : data_from_string(data_or_body)
        body = data_or_body.respond_to?(:key) ? nil : data_or_body
        {
          raw_body: body,
          raw_event_type: data["resource_name"].to_sym,
          raw_event_id: nil,
          payment_processor: :gumroad,
          amount: {
            paid: data["price"].to_i,
            currency: data["currency"].upcase,
          },
          customer: {
            id: data["purchaser_id"].to_s,
            email: data["email"],
            name: data["full_name"],
          },
        }.compact
      end

      def parse(request)
        normalize(request.body)
      end

      private def read_and_rewind(body)
        if body.respond_to?(:read)
          body = body.read
          body.rewind
        else
          body
        end
      end

      private def data_from_string(body)
        WEBrick::HTTPUtils.parse_query(read_and_rewind(body))
      end
    end
    Compensated.event_parsers.push(Gumroad::EventParser.new)
  end
end
