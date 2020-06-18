ParameterType(
  name: 'spec_helper',
  regexp: /`.*`/,
  transformer: ->(s) { s.gsub("`", '') },
  use_for_snippets: true
)


Given("we have included the `Compensated::Spec::Helpers` mixin in my testing framework") do
  include Compensated::Spec::Helpers
end

When("I call {spec_helper} for a {string} fixture with the following overrides:") do |spec_helper, fixture_name, table|
  @fixture_output = compensated_event_body(fixture_name, overrides: table.hashes)
end

When("I call {spec_helper} for a {string} fixture") do |spec_helper, fixture_name|
  @fixture_output =  case spec_helper
    when 'compensated_event_body'
      compensated_event_body(fixture_name)
    else
      raise "Unknown spec helper, `#{spec_helper}`"
    end
end

Then("the fixture output is the content of the {string} fixture") do |fixture_name|
  expect(@fixture_output).to eql(compensated_event_body(fixture_name))
end

Then("the fixture output has {int} at {string}") do |exected_value, lookup_path|
  expect(JsonPath.on(@fixture_output, lookup_path).first.to_i).to eql(exected_value)
end

Then("the fixture output is a JSON string of Apple's {string} in-app purchase notification event") do |event_type|
  # @see https://developer.apple.com/documentation/appstoreservernotifications/responsebody
  expect(JsonPath.on(@fixture_output, "$.notification_type").first.to_s).to eql(event_type)
end