Feature: Forwarding Proxy
  In order to leverage Compensated's event standardization
  As a Client who doesn't use Ruby
  I would like an executable that forwards events to my payment event listener

  Scenario: Forwarding proxy forwards all events to Downstream Server
    Given there is a Downstream Listener running
    And I am running `compensated-proxy` with the following command line arguments:
    | argument | value |
    | --forward-to | {{ downstreamListener.compensatedEventHandlerURI }}|
    When each our Source Event Fixtures are delivered to the running compensated proxy
    Then the Downstream Listener receives each of our Standardized Event Fixtures