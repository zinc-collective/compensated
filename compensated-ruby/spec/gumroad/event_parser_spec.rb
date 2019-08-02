require "compensated/gumroad"
require "rack"
module Compensated
  module Gumroad
    RSpec.describe EventParser do
      def fake_request(fixture)
        content = fixture_content(fixture)
        data = fixture_data(fixture)
        PaymentProcessorEventRequest.new(double(form_data?: true, params: data, body: content))
      end

      def fixture_content(fixture)
        fixture.nil? ? nil : File.read(File.join(__dir__, "fixtures", fixture))
      end

      def fixture_data(fixture)
        Rack::Utils.default_query_parser.parse_query(fixture_content(fixture))
      end

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers.find { |ep| ep.instance_of?(Gumroad::EventParser) }).not_to be_nil
      end

      subject(:event_parser) { EventParser.new }

      describe "#normalize(body_or_data)" do
        subject(:data) { event_parser.normalize(body_or_data) }
        context "when it's a string of body data" do
          let(:body_or_data) { fixture_content("sample-ping.as.multipart") }
          it { is_expected.to include raw_body: body_or_data }
          it { is_expected.to include raw_event_type: :sale }
          it { is_expected.not_to have_key(:raw_event_id) }
          it { is_expected.to include payment_processor: :gumroad }
          it { is_expected.to include({amount: {paid: 20_00, currency: "USD"}}) }
          it { is_expected.to include({customer: {id: "5312883333252", email: "customer@example.com", name: "Foo Bar"}}) }
        end

        context "when it's a hash of that data" do
          let(:body_or_data) { fixture_data("sample-ping.as.multipart") }
          it { is_expected.not_to have_key(:raw_body) }
          it { is_expected.to include raw_event_type: :sale }
          it { is_expected.not_to have_key(:raw_event_id) }
          it { is_expected.to include payment_processor: :gumroad }
          it { is_expected.to include({amount: {paid: 20_00, currency: "USD"}}) }
          it { is_expected.to include({customer: {id: "5312883333252", email: "customer@example.com", name: "Foo Bar"}}) }
        end
      end

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
          it { is_expected.not_to have_key(:raw_event_id) }
          it { is_expected.to include payment_processor: :gumroad }
          it { is_expected.to include({amount: {paid: 20_00, currency: "USD"}}) }
          it { is_expected.to include({customer: {id: "5312883333252", email: "customer@example.com", name: "Foo Bar"}}) }
        end
      end
    end
  end
end
