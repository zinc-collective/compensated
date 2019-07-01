# Compensated
Compensated makes it easier to instrument your server and client with mechanisms for getting paid. It is designed as an event-driven system, with very few opinions about how your application is structured or communicates the information to the client, while providing affordances and guidance around consistent, reliable payment processing.

## Roadmap

1. Q3 2019 - compensated-ruby, compensated-ruby-stripe, and compensated-ruby-gumroad will provide affordances for Ruby/Rails apps to adjust data when subscriptions are created, payments succeed, or payments fail.
2. Q4 2019 - ???

## Architecture

Compensated's architecture draws from prior art such as [griddler](https://github.com/thoughtbot/griddler), [omniauth](https://github.com/omniauth/omniauth) and [expressjs](https://expressjs.com/). The goal of the design is to enable functionality without imposing demands on structures.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)


## License
While you may have access to this source code, it may not mean you are legally allowed to use it.
See [LICENSE.md](LICENSE.md)