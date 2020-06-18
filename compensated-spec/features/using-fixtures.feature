@0.1 @wip
Feature: Using Fixtures
  In order to not need to reverse engineer the event data structures across payment processors
  As a Client Developer
  I would like to apply the fixtures used when testing Compensated in my own projects

  Scenario: Applying an uninterpolated fixture within rspec
    Given we have included the `Compensated::Spec::Helpers` mixin in my testing framework
    When we generate the "stripe/charge.succeeded.api-v2014-11-05.json" fixture
    Then the fixture output is the content of the "stripe/charge.succeeded.api-v2014-11-05.json" fixture

  Scenario: Applying an interpolated fixture within rspec
    Given we have included the `Compensated::Spec::Helpers` mixin in my testing framework
    When we generate the "stripe/customer.subscription.deleted.api-v2019-12-03.json" fixture with the following overrides:
      | location             | value                  |
      | $.data.object.ended_at | 1576716505  |
    Then the fixture output has 1576716505 at "$.data.object.ended_at"