# frozen_string_literal: true

require 'net/http'

module Compensated
  module Stripe
    # Applys the Compensated Configuration to a Stripe account
    class ApplyCommand < Compensated::ApplyCommand
      API_URI = URI('https://api.stripe.com/v1/')
      def execute
        API_URI.user = options[:stripe_secret_key]
        # https://stripe.com/docs/billing/prices-guide

        Net::HTTP.start(API_URI.hostname, API_URI.port, use_ssl: true) do |http|
          configuration[:products].each do |product_configuration|
            product = find_or_create_product(product_configuration, http: http)
            raise "Can't find/create product for #{product_configuration}" unless product

            product_configuration[:prices].each do |price_configuration|
              price = find_or_create_price(price_configuration, product: product, http: http)
              raise "Can't find/create price #{price_configuration} for #{product_configuration}" unless price

              # Assembled from
              # https://stripe.com/docs/payments/checkout/client-subscription
              # TODO: Move this to Compensated and/or Support
              puts <<~DOCS
                Congratulations! You're set up to sell Convene for $20.00/mo.
                Embed the following HTML into your page!
                ```
                <script src="https://js.stripe.com/v3/"></script>
                <script>
                  var stripe = Stripe('#{options.fetch(:stripe_publishable_key, 'STRIPE_PUBLISHABLE_API_KEY')}');
                  function beginPurchaseFlow() {
                    stripe.redirectToCheckout({
                      lineItems: [{
                        // Replace with the ID of your price
                        price: '#{price[:id]}',
                        quantity: 1,
                      }],
                      mode: 'subscription',
                      successUrl: 'https://example.com/success',
                      cancelUrl: 'https://example.com/cancel',
                    }).then(function (result) {
                      // If `redirectToCheckout` fails due to a browser or network
                      // error, display the localized error message to your customer
                      // using `result.error.message`.
                    });
                  }
                  window.addEventListener('DOMContentLoaded', (event) => {
                    const beginPurchaseButtons = document.getElementsByClassName('begin-purchase-flow')
                    for(const beginPurchaseButton of beginPurchaseButtons) {
                      beginPurchaseButton.addEventListener('click', beginPurchaseFlow)
                    }
                  });
                </script>
                <button class="begin-purchase-flow">Buy Now</button>
                ```
              DOCS
            end
          end
        end
      end

      def api_uri(path)
        URI.join(API_URI, path)
      end

      def request(req, http:)
        req.basic_auth options[:stripe_secret_key], ''
        res = http.request(req)
        JSON.parse(res.body, symbolize_names: true)
      end

      def get(path, http:)
        request(Net::HTTP::Get.new(api_uri(path)), http: http)
      end

      def post(path, data, http:)
        req = Net::HTTP::Post.new(api_uri(path))
        req.form_data = data
        request(req, http: http)
      end

      # TODO: Move this to Compensated
      def find_or_create_product(product_configuration, http:)
        response_body = get('products', http: http)
        products = response_body[:data]

        product = products.find { |product| product[:name] == product_configuration[:name] }
        raise "Couldn't find product in first page of products..." if !product && response_body[:has_more]

        product ||= post('products', { name: product_configuration[:name] }, http: http)
      end

      # TODO: Move this to Compensated
      def find_or_create_price(price_configuration, product:, http:)
        # https://stripe.com/docs/api/prices/list#list_prices
        response_body = get('prices', http: http)
        prices = response_body[:data]

        price = prices.find do |potential_price|
          potential_price[:product] == product[:id] &&
            potential_price[:unit_amount] == price_configuration[:amount] &&
            potential_price[:currency].to_sym == price_configuration[:currency].to_sym
          potential_price[:recurring][:interval].to_sym == price_configuration[:interval].to_sym
        end

        raise "Couldn't find price in first page of prices..." if !price && response_body[:has_more]

        post('prices', { product: product[:id],
                         unit_amount: price_configuration[:amount],
                         nickname: price_configuration[:nickname],
                         currency: price_configuration[:currency],
                         "recurring[interval]": price_configuration[:interval] },
             http: http)
      end
    end
  end
end
