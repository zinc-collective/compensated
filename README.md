# Compensated

Compensated makes it easier to get paid by your users. It listens for events from your payment processors and normalizes them so you only have to write your payment handling code once. Compensated has very few opinions about how your application is structured while providing affordances and guidance around consistent, reliable payment processing.

## Goals

  - Make it easy for product and service developers to accept money from whichever payment processor they prefer with a low implementation or switching costs.
  - Establish an ethical and sustainable mechanism for contributing source code to the commons.

## Roadmap

1. [X] - Q3 2019 - compensated-ruby, compensated-ruby-stripe, and compensated-ruby-gumroad will provide affordances for Ruby/Rails apps to adjust data when subscriptions are created, payments succeed, or payments fail.
2. [X] - Q4 2019 - Bug fixes and enhancements to support existing clients
3. [ ] - Q1~Q2 2020 - Polish to the point of being a salable project.
    - [ ] Zee will do customer development work to figure out how the market responds to what we have.
    - [ ] Improve customer-facing documentation and web site so that people can make an informed buying decision and acquire a commercial-use license.
    - [ ] Improve contributor-facing documentation so folks can understand it when they open the code base; so that people don't think it's abandonware.
    - [ ] MVP of a plain-old-ruby  `Event` class so we can see the shape of the normalized Event and give an alternative to the nested hashes;
    - [ ] Stretch: Implement [a Rails Engine](https://guides.rubyonrails.org/engines.html) that encapsulates the basic domain model for easier integration with Rails apps
    - [ ] Stretch: So that people can code to the Compensated data structures and event stream in non-ruby code-bases. Possibly by implementing a lightweight proxy server that normalizes the events from the currently supported payment processors and forwards them to a single URL. Usage Example: `gem install compensated-proxy && compensated-proxy --forward-to=https://your-other-app.example.com/compensated_events`

## Architecture

Compensated's architecture draws from prior art such as [griddler](https://github.com/thoughtbot/griddler), [omniauth](https://github.com/omniauth/omniauth) and [expressjs](https://expressjs.com/). The goal of the design is to enable functionality without imposing demands on structures.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)


## License
While you may have access to this source code, it may not mean you are legally allowed to use it.
See [LICENSE.md](LICENSE.md)