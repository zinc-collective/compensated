require "compensated/gumroad"
module Compensated
  module Gumroad
    RSpec.describe(CSVEmitter) do
      def load_csv(fixture)
        File.open(File.join(__dir__, "fixtures", fixture))
      end
      describe "#parse(io_stream)" do
        it "normalizes each row into a payment processor event" do
          emitter = CSVEmitter.new
          events = emitter.parse(load_csv("example-export.csv"))
          expect(events[0]).to include({
            payment_processor: :gumroad,
            raw_event_type: :"purchase.completed",
            raw_event_id: "pur_fake-1",
            raw_body: 'pur_fake-1,Support,,person@example.com,false,2017-08-02,2017-08-02 16:26:27 +0000,10.0,0.0,0.0,10.0,0.65,9.35,,"","",12345,CA,United States,https://www.google.com/,0,0,(Bicycle),"",false,false,huxLm,661264979,"",{},5.0,5.0,false,"","",1,monthly,"",0.0,false,2019-02-02,""',
          })
          expect(events[1]).to include({
            payment_processor: :gumroad,
            raw_event_type: :"purchase.completed",
            raw_event_id: "pur_fake-2",
            raw_body: 'pur_fake-2,Support,,person@example.com,false,2017-09-02,2017-09-02 16:26:32 +0000,10.0,0.0,0.0,10.0,0.65,9.35,,"","",12345,CA,United States,https://www.google.com/,0,0,(Bicycle),"",true,false,huxLm,453382483,"",{},5.0,5.0,false,"","",1,monthly,"",0.0,false,2019-02-02,""',
          })
        end
      end
    end
  end
end
