const { defineParameterType } = require("cucumber");

// Provides a programmatic interface for interacting with data
// pull from the the {price} Cucumber Parameter Type
class Price {
  constructor(priceString) {
    this.priceString = priceString;
  }
}
Price.parser = /\$?(\d+) (USD) billed (monthly|annually)/;

/*
 * A custom Cucumber Parameter Type for reading Price data from steps.
 *
 * @see {@link https://cucumber.io/docs/cucumber/cucumber-expressions/#parameter-types}
 */
defineParameterType({
  name: "price",
  regexp: Price.parser,
  transformer: (priceString) => new Price(priceString),
});

/*
 * A Custom Parameter Type for Payment Gateways.
 * At present, it doesn't transform into anything, but it could
 * eventually.
 *
 * @see {@link https://cucumber.io/docs/cucumber/cucumber-expressions/#parameter-types}
 */
defineParameterType({
  name: "paymentGateway",
  regexp: /Stripe/,
  transformer: (pg) => pg,
});

/*
 * A Custom Parameter Type for our Compensated Packages
 *
 * @see {@link https://cucumber.io/docs/cucumber/cucumber-expressions/#parameter-types}
 */

defineParameterType({
  name: "compensatedPackage",
  regexp: /(compensated-ruby|compensated-proxy|compensated-spec)/,
  transformer: (package) => package,
});
