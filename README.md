# Compensated
[![Build Status](https://travis-ci.org/zinc-collective/compensated.svg?branch=0.X)](https://travis-ci.org/zinc-collective/compensated)

Compensated makes it easier to get paid by your users. It listens for events from your payment processors and transforms them so you only have to write your payment handling code once. Compensated has very few opinions about how your application is structured while providing affordances and guidance around consistent, reliable payment processing.

## Goals

  - Make it easy for product and service developers to accept money from whichever payment processor they prefer with a low implementation or switching costs.
  - Establish an ethical and sustainable mechanism for contributing source code to the commons.

## Roadmap

1. [X] - Q3 2019 - compensated-ruby, compensated-ruby-stripe, and compensated-ruby-gumroad will provide affordances for Ruby/Rails apps to transform data when subscriptions are created, payments succeed, or payments fail.
2. [X] - Q4 2019 - Bug fixes and enhancements to support existing clients
3. [ ] - Q1~Q2 2020 - Polish to the point of being a salable project and release 1.0

The current work in progress is [in our WIP board][compensated-wip].

## Architecture

Compensated's architecture draws from prior art such as [griddler](https://github.com/thoughtbot/griddler), [omniauth](https://github.com/omniauth/omniauth) and [expressjs](https://expressjs.com/). The goal of the design is to enable functionality without imposing demands on structures.

## Contributing

To get started, make sure you have [rbenv](https://github.com/rbenv/rbenv) installed, clone the repository and run `bin/setup-matrix` then run `bin/test-matrix`.

For further guidance, See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
While everyone has access to the source code, only non-commercial use is permitted. See [LICENSE.md for details](LICENSE.md).


[compensated-wip]: https://github.com/orgs/zinc-collective/projects/1