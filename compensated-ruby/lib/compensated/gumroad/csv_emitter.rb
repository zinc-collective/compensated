require "csv"
module Compensated
  module Gumroad
    class CSVEmitter
      def parse(io)
        CSV.new(io, headers: true).map do |row|
          {payment_processor: :gumroad,
           raw_event_type: :"csv.purchase_entry",
           raw_event_id: row["Purchase ID"],
           raw_body: row.to_s.strip,}
        end
      end
    end
  end
end
