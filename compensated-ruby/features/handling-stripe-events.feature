@stripe @event-handling
Feature: Handling Stripe Events
  In order to give my clients value because they paid me
  As a Client Developer
  I would like to be able to handle stripe events

  @future @security
  Scenario: Event handler rejects Unsigned Stripe Webhook Events
    Given Compensated is configured to reject unsigned Stripe Events
    When an Unsigned Stripe Event is request is passed into the Compensated::RequestHandler
    Then the Request Handler raises a Compensated::UnsignedEventError when transforming the event data

  @future @security
  Scenario: Event handler accepts Unsigned Stripe Webhook Events
    Given Compensated is configured to accept unsigned Stripe Events
    When an Unsigned Stripe Event is request is passed into the Compensated::RequestHandler
    Then the Request Handler transforms the event data