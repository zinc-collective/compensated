# Principles

1. Stability above all (no money, goodbye honey)
2. Collective action, Mutual accountability
3. Don't do or say anything offensive

You want to get paid, we (the Zinc Cooperative) want us all to get paid. Because web sites interface to [external payment processors](https://www.bis.org/cpmi/paysys/unitedstatescomp.pdf)), careful engineering is needed for robust code that will work for a long-time. [Compensated](https://github.com/zinc-collective/compensated/) delivers this code:
* as open source (DIY Principle #1) with the [Director of Community](https://github.com/zspencer) shepherding the alpha version; 
* by joining Zinc Collective (a CA limited liability company) so don't worry (DWR ... xref Principle #2);
* and future Functional as a Service (FaaS), payment terms to be discussed in a civil manner (Principle #3).

# Why the Legal bovine excrement
Because this Compensated interfaces with (for now, US only) financial payment system, Uncle Sam needs:
1. Regulatory compliance with pertinent regulations (eg [IRS 6050W](https://www.irs.gov/pub/irs-drop/n-09-19.pdf)). Now if this was just DIY it'd be an MIT license but since one of the proposed service tiers is a hosted FaaS, someone (guess who) is going to be on the hook for leaky code;
2. Any suspicious activity of individual transaction >$10k needs to be reported to [Financial Crimes Enforcement Network](https://www.fincen.gov), goodbye lunchtime;
3. Having responsibility without legal control is like carrying a gun with safety off, do you want to take over this project?

So, basically contributors transfer all ownership rights to Zinc Cooperative upon acceptance of their contributions into the primary Compensated /core repository. Furthermore, contributor's guarantee that they have the right to transfer ownership of their contributions or else certify documentation can be freely distributed ([CC BY-ND](https://creativecommons.org/share-your-work/licensing-examples/#nd) or [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/)); and shall indemnify us from any and all repercussions caused by a violation of this guarantee. The simplest way is to:
* understand why the [License Zero](https://guide.licensezero.com/#comparing-public-licenses) was selected noting the difference between public and private;
```
    def prosperity_license:
      if commercial_user:
        if within_trial_period:
          return 'free to use'
        else:
          return 'need to buy a private license'
      else:
       return 'free to use'
```
* grok how Creative Commons [non-derivative](https://creativecommons.org/share-your-work/licensing-examples/#nd) works for mixing different contributions;
* and what open source business models [work](https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1060.0547) focusing on certification.

# How to contrib meaningfully
Eat your own dogfood. This is the standard corporate idea development
![DevOps](./contrib/img/DevOps-BadApple.png)
That is what the credit card processing industry looks like
![pureed mush](./contrib/img/US-cardProcessing.png)
And this is what we hope to achieve
![wormed_apple](./contrib/img/Compensated.png)

Did you know that if you want to tip someone $10, that at least 5.9% is docked by the system (so much for donating to your favorite geek cause)? Well what our members want is a simple Internet Payment Interface (IPI), a microservice that will interface with existing payment processors such as [Stripe](https://memberful.com/blog/stripe-vs-paypal/). In fact, you should be able to issue invoice without via web post worrying about fraudsters helping themselves to your hard earned sweat. So this project appreciates
* security review (with enough eyeballs, all bugs are [shallow](https://en.wikipedia.org/wiki/Linus%27s_law));
* use the testbed service to round-trip betweeen yourself and a chargeback reversion point;
* translate into Spanish or other minority languages to allow underrepresented minorities to participate and code to live (Principle #2).

# Libre not Gratis
No money, goodbye honey. We all need to live so making it easy for clients to pay for your time or tip should be as simple as possible. The initial pricing for alpha version (including updates) is flat $500. Of course, for small businesses we offer 10 internet payment interfaces for initial $5k (upgradeable). People who contribute to the core will be able to bundle this software into integration work for SMEs. A decent programmer can charge $250/hr so we believe the fee is reasonable compared with 20hrs debugging webbackends to multiple payment processors from different frameworks.

# Devil in the Details
## Ground Rules
Welcome! First off; _**THANK YOU**_ for your interest in contributing to Compensated! We know that your time is valuable; so let's get started! 

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119][rfc-2119].

### Contributor Ground Rules

Based on Princple #2 (collective action);
- Contributors _must_ comply with our [code of conduct][code-of-conduct].
- Contributors _must_ [assign ownership][assign-ownership] of their coding contributions to Zinc Cooperative.
- Contributors _should_ keep documentation up to date and allow us to redistribute under Prosperity License.
- Contributors _must not_ commit directly to the 0.X, 1.X or 2.X branches unless expressly invited.
- Contributors _should_ [ask for help][get-help] when they get stuck.
- Contributors _may_ build on top of other Contributors un-merged branches.

### Maintainer Ground Rules

Based on Principle #1 (stability above all):
- Maintainers _must_ comply with our [code of conduct][code-of-conduct].
- Maintainers _must_ perform regression testing prior to release.
- Maintainers _must_ ensure that all feedback provided to Contributors is
  specific, actionable, and kind.
- Maintainers _must not_ erase authorship information from any Contributors.
- Maintainers _should_ acknowledge Contributors issues and patches within two
  weeks of submission.

## How can I contribute...

Based on the Principle of collective action:
- since we [Eat our own Dogfood](https://en.wikipedia.org/wiki/Eating_your_own_dog_food) everyone _shall_ use the APIs as documented officially;
- Contributors and Maintainers _should_ raise issues when you see security flaws, vulnerable attack surfaces or any suspicous back doors in the code;
- Maintainers _can_ recommend meritorious Contributors of documentation or useful feedback to be added to CREDITS.
- Commentors _should not_ use abusive or denigrating language in the comments, remember that github records every change of history.
- Commentors _may_ line edit or submit spelling/syntactic corrections [default US Engish] where they see fit.
- it is _required_ that licensees outside the Zinc Cooperative indemnity us as we can only guarantee integrity of the hosted service.
- Contributors _love_ to have their skill and responsivity recognised so please +[1-5] @zspencer (or any noteworthy individual) when you can.

### Security concerns?

We need to create a more formal responsible security disclosure process; but in
the meantime, we strongly encourage people with security concerns to [create a
ticket][issue-tracker] explaining their concerns. If the concern is a
vulnerability in a released version of compensated; please [email the
maintainers][email-maintainers].

### Bug fixes?

We consider any gaps between what you _expected_ Compensated to do and what it
_actually did_ to be a bug. It makes it easier for us to fix things when bug
reports clearly express what was expected and what actually happened.

But don't let that stop you! We'd prefer to hear about what was surprising even
if you can't reproduce it or would need help figuring out how to communicate the
issue effectively.

If you notice something weird when working in Compensated; please [open a ticket
in our issue tracker][issue-tracker]. We'll do our best to prioritize fixing
bugs over adding features.

If you want to try squashing it yourself; we encourage you to review the
[development workflow][development-workflow].

### Documentation improvements?

Because Compensated is very early alpha software, it's light on documentation.
If you are trying to figure something out or have a question we would love for
you to [open a ticket][issue-tracker] requesting documentation improvements.

If you have an idea for what that documentation would look like, you can [use
the built in GitHub editor][editing-files-in-github] to [suggest a change using
a pull request!][creating-a-pull-request]

Serious contributors will have their sub-repositories in /contrib redistributed and given credit or compensation accordingly. This includes Work-for-Hire subcontractors and firms that are algned with our Principles.

### Find Something To Do

Look at the open tickets in our [issue tracker][issue-tracker]. Items labeled
"Help Wanted" are where we would appreciate some help. Items labeled "Good First
Issue" are where we think new contributors would be able to chip in effectively.
If there aren't any labeled with these two things; feel free to pick something
else!

Now that you've got something to do,

### Learn the System

Once you've [found something to do][find-something-to-do], you'll want to [clone
the repository][cloning-a-repository] and review the [product
design][product-documentation] and [architecture
documentation][architecture-documentation] to develop a firmer grasp of the
underlying mental models.

### Make a Change

First, [review the dependencies][dependencies] and make sure you have installed
all the tools you need to start working.

You may also run `bin/setup` from the top level directory or a project specific
directory and we will do our best to install the dependencies for your system.
If that doesn't work, read the source of `bin/setup` and the contents of the
nearest README to try and get it working; and then [ask for help][get-help]

We encourage people to start off by writing a test that demonstrates the bug
they are attempting to fix or the use case they want to add.

Tests are ran by running `bin/test` within the top level directory or a
project-specific folder.

Ideally, there are at least two tests, a ["unit" test and a "system"
test][unit-and-system-tests]. If you are struggling to write either test, that
is OK! You can find examples of unit tests in the `spec/unit` folder and of
system tests in the `spec/system` folder. If you are still stuck, you can always
[ask for help][get-help].

Once you have a test that help you feel confident you will know that the change
you made has the impact you want, dive on in to writing code! Reviewing the
[architecture documentation][architecture-documentation] and the nearest README
should get you headed in the right direction. If not, [ask for help][get-help]!

### Submit a Patch

We encourage contributors to [create a pull request][creating-a-pull-request]
early, even if the work isn't 'done' as this is the easiest way to [get the best
help][get-help]. This also makes it possible for other Contributors to build on
top of the work you've already done, instead of needing to reinvent the wheel.

We encourage Contributors to follow a branch naming schema like for bugs that
looks something like `fix/apple-iap/<words-describing-fix>`; and for features
looks something like `enhance/stripe/<words-describing-improvement>`. However,
feel free to name your branches in the way that feels most comfortable to you.

# Future Changes

## Getting Help

We have two vectors for getting help; one is through [opening a ticket in our
issue tracker][issue-tracker], where we will do our best to provide support in a
timely manner.

For businesses with greater support needs, we offer professional support at
\$250USD per hour. Support may be scheduled by [emailing
compensated-maintainers@zinc.coop][email-maintainers].

## Internal
### Features?

We are happy to continue building compensated in the direction our current
clients and projects need it to; but we'd _love_ to hear what you wish it would
do! To make a feature request, [create an issue in our issue
tracker][issue-tracker].

You can also take a stab at implementing the feature yourself! If you do, we
encourage you to [create a pull request][creating-a-pull-request] as soon as you
get started, even if it's not working yet! This makes it easier to see what is
in flight, and gives you the ability ask for help by mentioning
[@zinc-collective/compensated-maintainers][compensated-maintainers]. We'll
happily work with you to get it refined and merged in!

## Development Guide

The development guide is a work in progress, and is intended to serve as a
starting point for people who would like to directly modify Compensated to fix a
bug or enhance a feature.

If you have an idea of what change you would like to make, start [learning the
system][learn-the-system]. If you are already comfortable with Compensated's
product design and arhictecture, you can [start working on the
change][making-a-change]. For everyone else, let's [find something to
do!][find-something-to-do]

## External Legal Matters

Compensated uses a proprietary license for commercial use. This ensures we can
maintain the library and related services over the long haul (Principle #1), as well as gives
us the right to deny a license to organizations who freeride or we do not want to allow to
benefit from our labor (Libre not Gratis). 
Given the alpha nature of 0.x codebase, Zinc will grant a waiver from monthly fees in return for a lump sum including all upgrades (basically trial period ends when 1.x is released);

### Assignment of Ownership to Zinc Collective

In order to unambiguosly own and sell Compensated as a commercial product, Zinc
must have the legal copyright associated with the entire codebase. Any code you create
which is merged must be owned by Zinc. We're not trying to be a jerk, it's the
way it works. (Shamelessly lifted from [SideKiq Pro's Commercial Collaboration
Guide][sidekiq-pro-commercial-collaboration])

Before we can merge patches, we will need you to grant us all rights to the work
you perform on Compensated to Zinc. You can do this by sending "I assign all
rights, including copyright, to any future Compensated work by myself to Zinc
Collective LLC." to [the maintainer mailing list][email-maintainers] or as a
comment on your [patch][creating-a-pull-request]. There are more sophisticated forms to be signed if you are an entity or independent software developer which protect both parties.

### No Forking without Express Permission
Compensated is owned by the members as per operating agreement and each version is licensed to outsiders.

### Service Level and Privacy
When Compensated becomes mature enough to be a hosted service, then additional Terms and Conditions will apply under US Uniform Commercial Code. We welcome discussions on co-branding or more formal certification. As this codebase is hosted on a public github repository, compliance with [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) is outside existing resource capability but we are willing to discuss international concerns.

# References
[development-workflow]: #development-guide
[find-something-to-do]: #find-something-to-do
[learn-the-system]: #learn-the-system
[making-a-change]: #make-a-change
[get-help]: #getting-help
[assign-ownership]: #assignment-of-ownership-to-zinc-collective
[architecture-documentation]: ./design/ARCHITECTURE.md
[product-documentation]: ./design/README.md
[code-of-conduct]: ./CODE_OF_CONDUCT.md
[compensated-maintainers]:
  https://github.com/orgs/zinc-collective/teams/compensated-maintainers
[cloning-a-repository]:
  https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository
[creating-a-pull-request]:
  https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request
[editing-files-in-github]:
  https://help.github.com/en/github/managing-files-in-a-repository/editing-files-in-your-repository
[email-maintainers]: mailto:compensated-maintainers@zinc.coop
[issue-tracker]: https://github.com/zinc-collective/compensated/issues
[rfc-2119]: https://tools.ietf.org/html/rfc2119
[sidekiq-pro-commercial-collaboration]:
  https://github.com/mperham/sidekiq/wiki/Commercial-collaboration
[unit-and-system-tests]:
  http://softwaretestingfundamentals.com/software-testing-levels/

