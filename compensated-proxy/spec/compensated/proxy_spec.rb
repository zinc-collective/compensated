
require_relative '../../../compensated-ruby/spec/fixtures'

require 'compensated/stripe'
RSpec.describe Compensated::Proxy do

  include Compensated::Spec::Helpers

  it "has a version number" do
    expect(Compensated::Proxy::VERSION).not_to be nil
  end

  let(:interpolate) { {} }
  # TODO: Maybe pull the spec helpers into a `compensated-spec` gem
  # that will make it easier to leverage the fixtures when testing compensated.
  let(:template_file_path) { fixture_path(Pathname.new(__dir__).join('..', '..', '..', 'compensated-ruby', 'spec', 'stripe'), fixture) }
  let(:request) { fake_request(template_file_path, interpolate: interpolate) }
  let(:fixture) { "customer.subscription.updated.api-v2019-12-03.json" }

  it "forwards the standardized body" do
    http_client = class_double(Net::HTTP, post: :true)
    forwarder = Compensated::Proxy::Forwarder.new(to: 'http://localhost:8080/compensated-event-listener', http_client: http_client)

    proxy_service = Compensated::Proxy::Service.new(forwarder: forwarder )

    proxy_service.handle(request)

    expect(http_client).to have_received(:post).with(
      URI('http://localhost:8080/compensated-event-listener'),
      '{"raw_event_type":"customer.subscription.updated","raw_event_id":"evt_abc1234","payment_processor":"stripe","amount":{},"customer":{"id":"cus_abcd1234"},"invoice":null,"products":[{"sku":"prod_abcd1234","purchased":"2020-02-07 23:00:00 -0800","quantity":1,"expiration":"2020-05-08 00:00:00 -0700","subscription":{"id":"sub_abcd1234","period":{"start":"2020-04-08 00:00:00 -0700","end":"2020-05-08 00:00:00 -0700"},"status":"active"},"plan":{"sku":"plan_abcd1234","name":"Monthly","interval":{"period":"month","count":1}}}],"timestamp":"2020-04-08 00:00:20 -0700"}',
       "Content-Type" => "application/json"

    )
  end
end
