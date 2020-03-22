# Principles
1. Whoever writes the code, choses the license
2. Collective action, Mutual accountability
3. Don't do or say anything that you'd want your mother to know

# Why the Legal bovine excrement
Because this interfaces financial payment system, Uncle Sam needs 
1. Regulatory compliance with pertinent regulations [TBC title&section], now if this was just DIY it'd be an MIT license but since one of the service tiers is a hosted FaaS, someone (guess who) is going to be on the hook for leaky code
2. Any suspicious activity of individual transaction >$10k needs to be reported to [Financial Crimes Enforcement Network](https://www.fincen.gov), goodbye lunchtime
3. Having responsibility without legal control is like carrying a gun with safety off, do you want to take over this project?

So, basically contributors transfer all ownership rights to ZTI upon acceptance of their contributions into the primary ZTI repository. Further, contributor's guarantee that they have the right to transfer ownership of their contributions; and shall indemnify ZTI from any and all repercussions caused by a violation of this guarantee. The simplest way is to understand
* [License Zero](https://guide.licensezero.com/#comparing-public-licenses) the difference between public and private;
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
* Reasoning behind Creative Commons [non-derivative](https://creativecommons.org/share-your-work/licensing-examples/#nd) works
* and what open source business models [work](https://pubsonline.informs.org/doi/abs/10.1287/mnsc.1060.0547)

# How to contrib meaningfully
Eat your own dogfood. This is the standard corporate idea development
![DevOps](./contrib/img/DevOps-BadApple.png)
That is why the credit card processing industry looks like
![pureed mush](./contrib/img/US-cardProcessing.png)

You know that if you want to tip someone $10 that 28% is docked by the banks? Well what ZTI wants is a simple Internet Payment Interface (IPI), a microservice that will ... {do what Zee?}. In fact, you should be able to do a one-click invoice without worrying about fraudsters helping themselves to your hard earned sweat. So this project appreciates
* security review (with enough eyes, all bugs are shallow);
* use the testbed service to round-trip betweeen yourself and a chargeback reversion point;
* translate into Spanish or other minority languages to allow underrepresented minorities to participate

# Libre not Gratis
No money, goodbye honey. We all need to live so making it easy for clients to pay your time should be as simple as possible. The initial pricing is $500/year which will be charged as $10/week with a chargeback on Xmas and [TBD Easter or random cause?]. We make it easy for the casual coding suspending the fee if you want to take a break (min 2 weeks). Of course, for small businesses we offer 10 internet payment interfaces for $5k (plus transaction volume of 0.1% above [TBC $75k]). People who contribute to the core will be able to bundle this software into work for SMEs. A decent programmer can charge $250/hr so we believe the fee is reasonable considering the red tape involved.
