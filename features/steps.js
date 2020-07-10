const { Given, When, Then } = require('cucumber')
const ClientSandbox = require('./client-sandbox')
const ContributorSandbox = require('./contributor-sandbox')
const assert = require('assert').strict

Given(
  'Compensated is configured with a clean {paymentGateway} account',
  function (paymentGateway) {
    return (this.clientSandbox = new ClientSandbox(paymentGateway))
  }
)

Given('the following language test matrix:', function (languageMatrix) {
  this.languageMatrix = languageMatrix.hashes()
})

Given('there is a compensated.json with the following data:', function (json) {
  return this.clientSandbox.createFileSync('compensated.json', json)
})

When('I run `compensated apply`', function () {
  return this.clientSandbox.executeSync('bundle exec compensated apply')
})

When(
  'I run the setup and test scripts for {compensatedPackage} on each version',
  { timeout: -1 },
  async function (compensatedPackage) {
    this.commandResults = await Promise.all(
      this.languageMatrix.map((language) =>
        new ContributorSandbox(language, compensatedPackage).spawn(
          'bin/setup && bin/test'
        )
      )
    )
  }
)

Then(
  'the {string} Product has a {string} Price of {price} in {paymentGateway}',
  function (productName, priceName, price, paymentGateway) {
    // Write code here that turns the phrase above into concrete actions
    return 'pending'
  }
)

Then('a {string} Product is created in {paymentGateway}', function (
  string,
  paymentGateway
) {
  // Write code here that turns the phrase above into concrete actions
  return 'pending'
})

Then('all the commands passed', function () {
  this.commandResults.forEach((result) => {
    assert.strictEqual(result.code, 0)
  })
})
