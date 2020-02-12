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

        context "when the input event is JSON parsed from a stripe customer.subscription.deleted event from Stripe API v2019-12-03" do
          let(:request) { fake_request("customer.subscription.deleted.api-v2019-12-03.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice payment succeeded event from Stripe API v2014-11-05" do
          let(:request) { fake_request("invoice.payment_succeeded.api-v2014-11-05.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice.payment_succeeded event from Stripe API v2019-12-03" do
          let(:request) { fake_request("invoice.payment_succeeded.api-v2019-12-03.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice.payment_failed event from Stripe API v2019-12-03" do
          let(:request) { fake_request("invoice.payment_failed.api-v2019-12-03.json") }
          it { is_expected.to eql true }
        end
      end

      describe "#normalize(data)" do
        subject(:data) { event_parser.normalize(input) }
        let(:request) { fake_request("charge.succeeded.api-v2014-11-05.json") }
        context "when the input is a string of the body" do
          let(:input) { request.body.read }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"charge.succeeded" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it { is_expected.to include timestamp: Time.at(request.data[:created]) }
          it {
            is_expected.to include amount: {
              paid: 4_00,
              currency: "USD",
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_00000000000000",
            }
          }
        end

        context "when the input is a hash of data" do
          let(:input) { request.data }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"charge.succeeded" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include amount: {
              paid: 4_00,
              currency: "USD",
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_00000000000000",
            }
          }
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
          it {
            is_expected.to include amount: {
              paid: 4_00,
              currency: "USD",
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_00000000000000",
            }
          }
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
        context "when the input event is JSON parsed from a Stripe invoice.payment_succeeded event from Stripe API v2019-12-03" do
          let(:request) { fake_request("invoice.payment_succeeded.api-v2019-12-03.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"invoice.payment_succeeded" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include amount: {
              due: 5_00,
              paid: 5_00,
              remaining: 0_0,
              currency: "USD",
            }
          }

          it {
            is_expected.to include invoice: {
              id: request.data[:data][:object][:id],
              created: Time.at(request.data[:data][:object][:created])
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_fake_customer",
              email: "customer@example.com"
            }
          }
          it {
            is_expected.to include products: [
              {
                sku: request.data[:data][:object][:lines][:data][0][:plan][:product],
                purchased: Time.at(request.data[:data][:object][:status_transitions][:paid_at]),
                expiration: Time.at(request.data[:data][:object][:lines][:data][0][:period][:end]),
                description: request.data[:data][:object][:lines][:data][0][:description],
                quantity: request.data[:data][:object][:lines][:data][0][:quantity],
                subscription: {
                  id: request.data[:data][:object][:lines][:data][0][:subscription]
                },
                plan: {
                  sku: request.data[:data][:object][:lines][:data][0][:plan][:id],
                  name: request.data[:data][:object][:lines][:data][0][:plan][:nickname],
                  interval: {
                    period: request.data[:data][:object][:lines][:data][0][:plan][:interval],
                    count: request.data[:data][:object][:lines][:data][0][:plan][:interval_count]
                  }
                }
              }
          ]
        }

        end

        context "when the input event is JSON parsed from a Stripe invoice.payment_failed event from Stripe API v2019-12-03" do
          let(:request) { fake_request("invoice.payment_failed.api-v2019-12-03.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"invoice.payment_failed" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include amount: {
              due: 20_00,
              paid: 0_00,
              remaining: 20_00,
              currency: "USD",
            }
          }
          it {
            is_expected.to include customer: {
              id: "cus_GNyhubbpJ6cYQM"
            }
          }
        end

        context "when the input event is JSON parsed from a Stripe customer.subscription.deleted event from Stripe API v2019-12-03" do
          let(:request) { fake_request("customer.subscription.deleted.api-v2019-12-03.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"customer.subscription.deleted" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include customer: {
              id: "cus_fake_customer"
            }
          }
        end
      end
    end
  end
end
