require "compensated/apple_iap/event_parser"
module Compensated
  module AppleIap
    RSpec.describe EventParser do
      def fake_request(fixture)
        body = fixture.nil? ? nil : File.open(File.join(__dir__, "fixtures", fixture))
        PaymentProcessorEventRequest.new(double(form_data?: false, body: body))
      end

      it "Adds itself to the list of event parses available to compensated" do
        expect(Compensated.event_parsers.find { |ep| ep.instance_of?(AppleIap::EventParser) }).not_to be_nil
      end

      subject(:event_parser) { EventParser.new }
      describe "#parses?(request)" do
        subject(:parses?) { event_parser.parses?(request) }
        context "when the request body is nil" do
          let(:request) { fake_request(nil) }
          it { is_expected.to eql false }
        end

        context "when the input event is JSON parsed from an interactive-renewal event from apple" do
          let(:request) { fake_request("interactive-renewal.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a cancel event from apple" do
          let(:request) { fake_request("cancel-GUESS.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a DID_CHANGE_RENEWAL_PREF event from apple" do
          let(:request) { fake_request("did-change-renewal-pref-GUESS.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a did-change-renewal-status event from apple" do
          let(:request) { fake_request("did-change-renewal-status.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a did-fail-to-renew event from apple" do
          let(:request) { fake_request("did-fail-to-renew-GUESS.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from an INITIAL_BUY event from apple" do
          let(:request) { fake_request("initial-buy.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from an RENEWAL event from apple" do
          let(:request) { fake_request("renewal.json") }
          it { is_expected.to eql true }
        end

        context "when the input event is JSON parsed from a DID_RECOVER event from apple" do
          let(:request) { fake_request("did-recover.json") }
          it { is_expected.to eql true }
        end
      end

      describe "#normalize(data)" do
        subject(:data) { event_parser.normalize(input) }
        let(:request) { fake_request("interactive-renewal.json") }
        context "when the input is a string of the body" do
          let(:input) { request.body.read }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :INTERACTIVE_RENEWAL }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }
          it {
            is_expected.to include products: [
              {sku: request.data[:latest_receipt_info][:product_id],
               purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
               expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),},
            ]
          }
          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
        end

        context "when the input is a hash of data" do
          let(:input) { request.data }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :INTERACTIVE_RENEWAL }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }
          it {
            is_expected.to include products: [
              {
                sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),
              },
            ]
          }
          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
        end
      end

      describe "#parse(request)" do
        subject(:event) { event_parser.parse(request) }
        context "when the input event is JSON parsed from a apple_iap CANCEL event from apple_iap" do
          let(:request) { fake_request("cancel-GUESS.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :CANCEL }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),
                cancelled: DateTime.parse(request.data[:latest_receipt_info][:cancellation_date]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap DID_CHANGE_RENEWAL_PREF event from apple_iap" do
          let(:request) { fake_request("did-change-renewal-pref-GUESS.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :DID_CHANGE_RENEWAL_PREF }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap DID_FAIL_TO_RENEW event from apple_iap" do
          let(:request) { fake_request("did-fail-to-renew-GUESS.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :DID_FAIL_TO_RENEW }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap DID_RECOVER event from apple_iap" do
          let(:request) { fake_request("did-recover.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :DID_RECOVER }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap INTERACTIVE_RENEWAL event from apple_iap" do
          let(:request) { fake_request("interactive-renewal.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :INTERACTIVE_RENEWAL }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap RENEWAL event from apple_iap" do
          let(:request) { fake_request("renewal.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :RENEWAL }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap INITIAL_BUY event from apple_iap" do
          let(:request) { fake_request("initial-buy.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :INITIAL_BUY }
          it { is_expected.to include raw_event_id: request.data[:latest_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it { is_expected.not_to have_key(:amount) }

          it {
            is_expected.to include products:
              [{sku: request.data[:latest_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_receipt_info][:expires_date_formatted]),}]
          }

          it {
            is_expected.to include customer: {
              id: request.data[:latest_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:latest_receipt_info][:purchase_date]) }
        end

        context "when the input event is JSON parsed from a apple_iap invoice.payment_succeeded event from apple_iap" do
          let(:request) { fake_request("did-change-renewal-status.json") }
          it { is_expected.to include raw_body: Compensated.json_adapter.dump(request.data) }
          it { is_expected.to include raw_event_type: :DID_CHANGE_RENEWAL_STATUS }
          it { is_expected.to include raw_event_id: request.data[:latest_expired_receipt_info][:transaction_id] }
          it { is_expected.to include payment_processor: :apple_iap }
          it {
            is_expected.to include products:
              [{sku: request.data[:latest_expired_receipt_info][:product_id],
                purchased: DateTime.parse(request.data[:latest_expired_receipt_info][:purchase_date]),
                expiration: DateTime.parse(request.data[:latest_expired_receipt_info][:expires_date_formatted]),}]
          }

          it { is_expected.not_to have_key(:amount) }
          it {
            is_expected.to include customer: {
              id: request.data[:latest_expired_receipt_info][:original_transaction_id],
            }
          }
          it { is_expected.to include timestamp: DateTime.parse(request.data[:auto_renew_status_change_date]) }
        end
      end
    end
  end
end
