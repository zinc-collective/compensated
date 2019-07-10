require "compensated"
module Compensated
  RSpec.describe PaymentProcessorEventRequestHandler do
    describe "#normalized_event_data" do
      let(:handler) { described_class.new(double(form_data?: true, params: {field: :value})) }
      context "when it can be parsed" do
        it "passes the request through to the parser" do
          allow(Compensated).to receive(:event_parsers).and_return([double(parses?: true, parse: :data!)])
          expect(handler.normalized_event_data).to eql(:data!)
        end
      end

      context "when the event cannot be parsed" do
        it "Raises an exception" do
          allow(Compensated).to receive(:event_parsers).and_return([double(parses?: false)])
          expect { handler.normalized_event_data }.to raise_error(NoParserForEventError)
        end
      end
    end
  end
end
