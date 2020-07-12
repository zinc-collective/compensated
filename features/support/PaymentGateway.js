const Stripe = require('stripe')
const http = require('http')

module.exports = class PaymentGateway {
  constructor({ type, secretKey }) {
    this.type = type;
    if(this.type === 'Stripe') {
      this.stripe = Stripe(secretKey);
    }
  }

  products() {
    return new Promise((resolve, reject) => {
      this.stripe.products.list({limit: 100}, (err, products) => {
        if(err) { return reject(err) }
        resolve(products.data)
      })
    })
  }
}
