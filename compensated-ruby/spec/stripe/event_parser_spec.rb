require "compensated/stripe"
module Compensated
  module Stripe
    RSpec.describe EventParser do
      def fake_request(fixture)
        body = fixture.nil? ? nil : File.open(File.join(__dir__, "fixtures", fixture))
        PaymentProcessorEventRequest.new(double(form_data?: false, body: body))
      end

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers.find { |ep| ep.instance_of?(Stripe::EventParser) }).not_to be_nil
      end

      subject(:event_parser) { EventParser.new }
      describe "#parses?(request)" do
        subject(:parses?) { event_parser.parses?(request) }
        context "when the request body is nil" do
          let(:request) { fake_request(nil) }
          it { is_expected.to eql false }
        end

        context "when the input event is JSON parsed from a stripe charge.succeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("charge.succeeded.api-v2014-11-05.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe charge.succeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("invoice.payment_succeeded.api-v2014-11-05.json") }
          it { is_expected.to eql true }
        end
      end

      describe "#parse(request)" do
        subject(:event) { event_parser.parse(request) }
        context "when the input event is JSON parsed from a Stripe charge.succeeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("charge.succeeded.api-v2014-11-05.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"charge.succeeded" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it { is_expected.to include amount: {paid: 4_00, currency: "USD"} }
        end

        context "when the input event is JSON parsed from a Stripe invoice.payment_succeeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("invoice.payment_succeeded.api-v2014-11-05.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"invoice.payment_succeeded" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include amount: {
              due: 0_0,
              paid: 0_0,
              remaining: 0_0,
              currency: "USD",
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_00000000000000",
              email: "customer@example.com",
              name: "Customer X",
            }
          }
        end
      end
    end
  end
end
