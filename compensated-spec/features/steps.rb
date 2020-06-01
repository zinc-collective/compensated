Given("we have included the `Compensated::Spec::Helpers` mixin in my testing framework") do
  include Compensated::Spec::Helpers
end

When("we generate the {string} fixture") do |fixture_name|
  @fixture_output = compensated_event_body(fixture_name)
end

When("we generate the {string} fixture with the following data:") do |fixture_name, table|
  @fixture_output = compensated_event_body(fixture_name, overrides: table.hashes)
end

Then("the fixture output is the content of the {string} fixture") do |fixture_name|
  expect(@fixture_output).to eql(compensated_event_body(fixture_name))
end

Then("the fixture output has {int} at {string}") do |exected_value, lookup_path|
  expect(JsonPath.on(@fixture_output, lookup_path).first.to_i).to eql(exected_value)
end