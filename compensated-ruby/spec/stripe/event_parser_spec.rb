require "compensated/stripe"
module Compensated
  module Stripe
    RSpec.describe EventParser do
      include Compensated::Spec::Helpers
      let(:interpolate) { {} }
      let(:template_file_path) { fixture_path(__dir__, fixture) }
      let(:request) { fake_request(template_file_path, interpolate: interpolate) }

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers.find { |ep| ep.instance_of?(Stripe::EventParser) }).not_to be_nil
      end

      subject(:event_parser) { EventParser.new }
      describe "#parses?(request)" do
        subject(:parses?) { event_parser.parses?(request) }
        context "when the request body is nil" do
          let(:request) { PaymentProcessorEventRequest.new(double(form_data?: false, body: nil)) }
          it { is_expected.to eql false }
        end

        context "when the input event is JSON parsed from a stripe charge.succeded event from Stripe API v2014-11-05" do
          let(:fixture) { "charge.succeeded.api-v2014-11-05.json" }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe customer.subscription.deleted event from Stripe API v2019-12-03" do
          let(:fixture) { "customer.subscription.deleted.api-v2019-12-03.json" }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe customer.subscription.updated event from Stripe API v2019-12-03" do
          let(:fixture) { "customer.subscription.updated.api-v2019-12-03.json" }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice payment succeeded event from Stripe API v2014-11-05" do
          let(:fixture) { "invoice.payment_succeeded.api-v2014-11-05.json" }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice.payment_succeeded event from Stripe API v2019-12-03" do
          let(:fixture) { "invoice.payment_succeeded.api-v2019-12-03.json" }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a stripe invoice.payment_failed event from Stripe API v2019-12-03" do
          let(:fixture) { "invoice.payment_failed.api-v2019-12-03.json" }
          it { is_expected.to eql true }
        end
      end

      describe "#normalize(data)" do
        subject(:data) { event_parser.normalize(input) }
        let(:fixture) { "charge.succeeded.api-v2014-11-05.json" }
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
          let(:fixture) { "charge.succeeded.api-v2014-11-05.json" }
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
          let(:fixture) { "invoice.payment_succeeded.api-v2014-11-05.json" }
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
          let(:fixture) { "invoice.payment_succeeded.api-v2019-12-03.json" }
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
          describe ':products' do
            subject(:products) { event[:products] }
            describe "[0]" do
              subject(:product) {  products[0] }
              it { is_expected.to include(sku: request.data[:data][:object][:lines][:data][0][:plan][:product]) }
              it { is_expected.to include(purchased: Time.at(request.data[:data][:object][:created])) }
              it { is_expected.to include(expiration: Time.at(request.data[:data][:object][:lines][:data][0][:period][:end])) }
              # DEPRECATED, see `subscription[:period][:end]`
              it { is_expected.to include(expiration: Time.at(request.data[:data][:object][:lines][:data][0][:period][:end])) }
              it { is_expected.to include(description: request.data[:data][:object][:lines][:data][0][:description]) }
              it { is_expected.to include(quantity: request.data[:data][:object][:lines][:data][0][:quantity]) }

              describe ":subscription" do
                subject(:subscription) { product[:subscription] }
                it { is_expected.to include(id: request.data[:data][:object][:lines][:data][0][:subscription])}
                it {
                  is_expected.to include(period: {
                    start: Time.at(request.data[:data][:object][:lines][:data][0][:period][:start]),
                    end: Time.at(request.data[:data][:object][:lines][:data][0][:period][:end]),
                  })
                }

                it { is_expected.to include(status: :active) }
              end

              describe ":plan" do
                subject(:plan) { product[:plan] }
                it { is_expected.to include(sku: request.data[:data][:object][:lines][:data][0][:plan][:id]) }
                it { is_expected.to include name: request.data[:data][:object][:lines][:data][0][:plan][:nickname] }
                it { is_expected.to include(
                      interval: {
                      period: request.data[:data][:object][:lines][:data][0][:plan][:interval],
                      count: request.data[:data][:object][:lines][:data][0][:plan][:interval_count]
                    })
                }
              end
            end
          end
        end

        context "when the input event is JSON parsed from a Stripe invoice.payment_failed event from Stripe API v2019-12-03" do
          let(:fixture) { "invoice.payment_failed.api-v2019-12-03.json" }
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


        context "when the input event is JSON parsed from a Stripe customer.subscription.updated event from Stripe API v2019-12-03" do
          let(:fixture) { "customer.subscription.updated.api-v2019-12-03.json" }
          describe ":products" do
            subject(:products) { event[:products] }
            describe "[0]" do
              subject(:product) { products[0] }
              describe ":subscription" do
                subject(:subscription) { product[:subscription] }
                it { is_expected.to include(period: { start: Time.at(1586329200), end: Time.at(1588921200) }) }
                context 'when the subscription does not have a canceled_at value set' do
                  let(:interpolate) { { data: { object: { canceled_at: nil } } } }
                  it { is_expected.to include(status: :active) }
                end

                context 'when the subscription does have a canceled_at value set' do
                  let(:interpolate) { { data: { object: { canceled_at: 1234 } } } }
                  it { is_expected.to include(status: :canceled) }
                end


              end
            end
          end
        end
        context "when the input event is JSON parsed from a Stripe customer.subscription.deleted event from Stripe API v2019-12-03" do
          let(:fixture) { "customer.subscription.deleted.api-v2019-12-03.json" }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :"customer.subscription.deleted" }
          it { is_expected.to include raw_event_id: request.data[:id] }
          it { is_expected.to include payment_processor: :stripe }
          it {
            is_expected.to include customer: {
              id: "cus_fake_customer"
            }
          }


          describe ":products" do
            subject(:products) { event[:products] }
            it { is_expected.not_to be_nil }
            describe "[0]" do
              subject(:product) { products[0] }
              describe ":subscription" do
                subject(:subscription) { product[:subscription] }
                context 'when data.object.ended_at is nil and data.object.canceled_at is present' do
                  let(:interpolate) { { data: { object: { ended_at: nil, canceled_at: 12345 } } } }
                  it { is_expected. to include(status: :canceled) }
                end

                context 'when data.object.ended_at is present and data.object.canceled_at is present' do
                  let(:interpolate) { { data: { object: { ended_at: 12345, canceled_at: 12345 } } } }
                  it { is_expected. to include(status: :ended) }
                end
              end
            end
          end
        end
      end
    end
  end
end
