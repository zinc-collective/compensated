Feature: Language Support
  In order to know whether or not Compensated will work in my ecosystem
  I would like to know which language versions each Compensated package supports

  @no-ci
  Scenario: `compensated-ruby` language support
    Given the following language test matrix:
      | ruby   |
      | 2.4.10 |
      | 2.5.8  |
      | 2.6.6  |
      | 2.7.1  |
    When I run the setup and test scripts for compensated-ruby on each version
    Then all the commands passed