require "compensated/gumroad"
require "rack"
module Compensated
  module Gumroad
    RSpec.describe EventParser do
      def fake_request(fixture)
        content = fixture.nil? ? nil : File.read(File.join(__dir__, "fixtures", fixture))
        data = Rack::Utils.default_query_parser.parse_query(content)
        PaymentProcessorEventRequest.new(double(form_data?: true, params: data, body: content))
      end

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers.find { |ep| ep.instance_of?(Gumroad::EventParser) }).not_to be_nil
      end

      subject(:event_parser) { EventParser.new }
      describe "#parses?(request)" do
        subject(:parses?) { event_parser.parses?(request) }
        context "when the request data is nil" do
          let(:request) { fake_request(nil) }
          it { is_expected.to eql false }
        end

        context "when the input is form data that contains data from gumroad" do
          let(:request) { fake_request("sample-ping.as.multipart") }
          it { is_expected.to eql true }
        end
      end

      describe "#parse(request)" do
        subject(:event) { event_parser.parse(request) }
        context "when the input event is JSON parsed from a Stripe charge.succeeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("sample-ping.as.multipart") }
          it { is_expected.to include raw_body: request.body }
          it { is_expected.to include raw_event_type: :sale }
          it { is_expected.to include raw_event_id: nil }
          it { is_expected.to include payment_processor: :gumroad }
          it { is_expected.to include({amount: {paid: 20_00, currency: "USD"}}) }
          it { is_expected.to include({payer: {id: "5312883333252", email: "customer@example.com"}}) }
        end
      end
    end
  end
end
