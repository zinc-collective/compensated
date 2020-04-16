require "webrick"
module Compensated
  module Gumroad
    class EventParser < Compensated::EventParser
      def parses?(request)
        # Gumroad pings are always form data
        return false unless request.form_data?
        keys = request.data.keys.map(&:to_sym)
        keys.include?(:seller_id) && keys.include?(:product_id) && keys.include?(:product_permalink) && request.data["product_permalink"].include?("gum.co")
      end

      def transform(data_or_body)
        data = extract(data_or_body)
        body = data_or_body.respond_to?(:key) ? nil : read_and_rewind(data_or_body)
        {
          raw_body: body,
          raw_event_type: data[:resource_name].to_sym,
          raw_event_id: nil,
          payment_processor: :gumroad,
          amount: {
            paid: data[:price].to_i,
            currency: data[:currency].upcase,
          },
          customer: {
            id: data[:purchaser_id].to_s,
            email: data[:email],
            name: data[:full_name],
          },
          timestamp: DateTime.parse(data[:sale_timestamp]),
        }.compact
      end

      def extract(data_or_body)
        data = if data_or_body.respond_to?(:key)
          data_or_body
        else
          data_from_string(data_or_body)
        end

        # Ruby 2.4 doesn't support Hash#transform_keys
        data = if data.respond_to?(:transform_keys)
          data.transform_keys(&:to_sym)
        else
          data.inject({}) do |hsh,(key,value)|
            hsh[key.to_sym] = value
            hsh
          end
        end
      end

      def parse(request)
        transform(request.body)
      end

      private def read_and_rewind(body)
        if body.respond_to?(:read)
          read_value = body.read
          body.rewind
          read_value
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
