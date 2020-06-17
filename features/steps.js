const { Given, When, Then } = require('cucumber')
const Sandbox = require('./sandbox')

Given('Compensated is configured with a clean {paymentGateway} account', function (paymentGateway) {
  this.sandbox = new Sandbox(paymentGateway)
})

Given('there is a compensated.json with the following data:', function (json) {
  return this.sandbox.createFileSync('compensated.json', json)
})

When('I run `compensated apply`', function () {
  return this.sandbox.executeSync('bundle exec compensated apply')
})

Then(
  'the {string} Product has a {string} Price of {price} in {paymentGateway}',
  function (productName, priceName, price, paymentGateway) {
    // Write code here that turns the phrase above into concrete actions
    return 'pending'
  }
)

Then('a {string} Product is created in {paymentGateway}', function (string, paymentGateway) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending'
})
