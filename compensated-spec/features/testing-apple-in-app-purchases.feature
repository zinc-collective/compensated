@0.1
Feature: Testing Apple In-App Purchases
  In order to be confident my app behaves correctly when selling via Apple In-App Purchases
  I would like test helpers for Apple In-App Purchase Events
  See: https://developer.apple.com/in-app-purchase/
       https://developer.apple.com/documentation/appstoreservernotifications/responsebody
       https://developer.apple.com/videos/play/wwdc2019/302/




  Scenario: Testing the `DID_RECOVER` notification type
    When I call `compensated_event_body` for a "apple_iap/did-recover.json" fixture
    Then the fixture output is a JSON string of Apple's "DID_RECOVER" in-app purchase notification event

  Scenario: Testing the `DID_CHANGE_RENEWAL_STATUS` notification type
    When I call `compensated_event_body` for a "apple_iap/did-change-renewal-status.json" fixture
    Then the fixture output is a JSON string of Apple's "DID_CHANGE_RENEWAL_STATUS" in-app purchase notification event

  Scenario: Testing the `INITIAL_BUY` notification type
    When I call `compensated_event_body` for a "apple_iap/initial-buy.json" fixture
    Then the fixture output is a JSON string of Apple's "INITIAL_BUY" in-app purchase notification event

  Scenario: Testing the `INTERACTIVE_RENEWAL` notification type
    When I call `compensated_event_body` for a "apple_iap/interactive-renewal.json" fixture
    Then the fixture output is a JSON string of Apple's "INTERACTIVE_RENEWAL" in-app purchase notification event

  Scenario: Testing the `RENEWAL` notification type
    When I call `compensated_event_body` for a "apple_iap/renewal.json" fixture
    Then the fixture output is a JSON string of Apple's "RENEWAL" in-app purchase notification event