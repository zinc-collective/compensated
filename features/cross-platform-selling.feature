Feature: Cross-Platform Selling
  In order to maximize my income
  I want to sell my products and services across channels


  @wip @developer-persona @stripe
  Scenario: Developer Creates Products and Prices in Stripe
  Given Compensated is configured with a clean Stripe account
  And there is a compensated.json with the following data:
  """
  {
    "products": [
      {
        "name": "Robot Delivery",
        "prices": [
          { "nickname": "Small month-to-month", "amount": 10_00, "currency": "usd", "interval": "monthly" },
          { "nickname": "Small full-year", "amount": 100_00, "currency": "usd", "interval": "annual" },
          { "nickname": "Medium month-to-month", "amount": 20_00, "currency": "usd", "interval": "monthly" },
          { "nickname": "Medium full-year", "amount": 200_00, "currency": "usd", "interval": "annual" },
          { "nickname": "Large month-to-month", "amount": 40_00, "currency": "usd", "interval": "monthly" },
          { "nickname": "Large full-year", "amount": 400_00, "currency": "usd", "interval": "annual" }
        ]
      }
    ]
  }
  """
  When I run `compensated apply`
  Then a "Robot Delivery" Product is created in Stripe
  And the "Robot Delivery" Product has a "Small month-to-month" Price of $10 USD billed monthly in Stripe
  And the "Robot Delivery" Product has a "Small full-year" Price of $100 USD billed annually in Stripe
  And the "Robot Delivery" Product has a "Medium month-to-month" Price of $20 USD billed monthly in Stripe
  And the "Robot Delivery" Product has a "Medium full-year" Price of $200 USD billed annually in Stripe
  And the "Robot Delivery" Product has a "Large month-to-month" Price of $40 USD billed monthly in Stripe
  And the "Robot Delivery" Product has a "Large full-year" Price of $400 USD billed annually in Stripe