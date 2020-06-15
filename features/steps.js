const { Given, When, Then } = require('cucumber')

Given('Compensated is configured with a clean {paymentGateway} account', function (paymentGateway) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Given('there is a compensated.json with the following data:', function (docString) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});


When('I run `compensated apply`', function () {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});

Then(
  "the {string} Product has a {string} Price of {price} in {paymentGateway}",
  function (productName, priceName, price, paymentGateway) {
    // Write code here that turns the phrase above into concrete actions
    return "pending";
  }
);


Then('a {string} Product is created in {paymentGateway}', function (string, paymentGateway) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending';
});