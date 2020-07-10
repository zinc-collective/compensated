# frozen_string_literal: true

require 'compensated/stripe'
RSpec.describe Compensated::Proxy do
  include Compensated::Spec::Helpers

  it 'has a version number' do
    expect(Compensated::Proxy::VERSION).not_to be nil
  end

  let(:overrides) { [] }
  let(:request) { compensated_fake_request("stripe/#{fixture}", overrides: overrides) }
  let(:fixture) { 'customer.subscription.updated.api-v2019-12-03.json' }

  it 'forwards the standardized body without the raw body' do
    http_client = class_double(Net::HTTP, post: :true)

    proxy_service = Compensated::Proxy.new(forward_to: 'http://localhost:8080/compensated-event-listener', http_client: http_client)

    proxy_service.handle(request)
    handler = Compensated::PaymentProcessorEventRequestHandler.new(request)
    data = handler.normalized_event_data
    data.delete(:raw_body)
    expect(http_client).to have_received(:post).with(
      URI('http://localhost:8080/compensated-event-listener'),
      JSON.dump(data),
      'Content-Type' => 'application/json'
    )
  end
end
