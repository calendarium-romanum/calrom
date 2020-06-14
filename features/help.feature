Feature: Help
  In order to be able to see which options and arguments the program accepts
  I want the command to understand standard options to print help.

  Scenario: Single letter option
    When I run `calrom -h`
    Then the exit status should be 0
    And the output should contain "Usage: calrom [options]"

  Scenario: Long option
    When I run `calrom --help`
    Then the exit status should be 0
    And the output should contain "Usage: calrom [options]"

  Scenario: program version
    When I run `calrom --version`
    Then the exit status should be 0
    And the output should match /calrom v\d+\.\d+.\d+/
