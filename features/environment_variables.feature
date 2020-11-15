Feature: Environment variables
  In order to facilitate convenient testing
  I want the command to support limited configuration through environment variables

  Scenario: set current date
    Given I set the environment variables to:
      | variable            | value      |
      | CALROM_CURRENT_DATE | 2000-01-01 |
    When I run `calrom --today`
    Then the exit status should be 0
    And the output should match /^2000-01-01/

  Scenario: set invalid current date
    Given I set the environment variables to:
      | variable            | value      |
      | CALROM_CURRENT_DATE | invalid    |
    When I run `calrom --today`
    Then the exit status should be 1
    And the stderr should contain "value of environment variable CALROM_CURRENT_DATE is not a valid date"
    And the stderr should not contain traceback
