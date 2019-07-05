require "compensated/stripe"
module Compensated
  module Stripe
    RSpec.describe EventParser do
      def parse_json(fixture)
        Compensated.json_adapter.parse(File.open(File.join(__dir__, 'fixtures', fixture)))
      end

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers).to include(described_class)
      end

      subject(:event_parser) { EventParser.new }
      describe "#parses?(input_event)" do
        subject(:parses?) { event_parser.parses?(input_event) }
        context "when the input event is nil" do
          let(:input_event) { nil }
          it { is_expected.to eql false }
        end

        context "when the input event is JSON parsed from a stripe charge.succeded event from Stripe API v2014-11-05" do
          let(:input_event) { parse_json("charge.succeeded.api-v2014-11-05.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe charge.succeded event from Stripe API v2014-11-05" do
          let(:input_event) { parse_json("invoice.payment_succeeded.api-v2014-11-05.json") }
          it { is_expected.to eql true }
        end
      end

      describe "#parse(input_event)" do
        subject(:event) { event_parser.parse(input_event) }
        context "when the input event is JSON parsed from a Stripe charge.succeeded event from Stripe API v2014-11-05" do
          let(:input_event) { parse_json("charge.succeeded.api-v2014-11-05.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(input_event) }
          it { is_expected.to include raw_event_type: :"charge.succeeded" }
          it { is_expected.to include raw_event_id: input_event[:id] }
          it { is_expected.to include payment_processor: :stripe }
        end

        context "when the input event is JSON parsed from a Stripe invoice.payment_succeeded event from Stripe API v2014-11-05" do
          let(:input_event) { parse_json("invoice.payment_succeeded.api-v2014-11-05.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(input_event) }
          it { is_expected.to include raw_event_type: :"invoice.payment_succeeded" }
          it { is_expected.to include raw_event_id: input_event[:id] }
          it { is_expected.to include payment_processor: :stripe }
        end
      end
    end
  end
end
