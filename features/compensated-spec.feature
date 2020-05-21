Feature: Compensated Specification
  In order to feel confident that I can leverage Compensated within my business
  As a Client Developer
  I would like there to be a specification I can programmatically apply to my projects

  Scenario: Applying an uninterpolated fixture within rspec
    Given a project using the rspec testing framework
    When the Client calls the `fixture` helper with an event
    Then the result is the full event body


  Scenario: Applying an interpolated fixture within rspec
    Given a project using the rspec testing framework
    When the Client calls `compensated_fixture('stripe/customer.subscription.deleted', data)` with the following data:
      | location             | value                  |
      | data.object.ended_at | { testSuiteStartTime } |
    Then the fixture output has {testSuiteStartTime} at data.object.ended_at


