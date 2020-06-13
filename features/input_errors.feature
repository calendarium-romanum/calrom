Feature: Handling input errors
  In order to avoid unpredictable behaviour and unhandled runtime errors
  I want the command to validate user input and report errors.

  Scenario: non-numeric year
    When I run `calrom abcde`
    Then the exit status should be 1
    And the stderr should contain "not a valid year abcde"
    And the stderr should not contain traceback

  Scenario: non-numeric month
    When I run `calrom -m abcde`
    Then the exit status should be 1
    And the stderr should contain "not a valid month abcde"
    And the stderr should not contain traceback

  Scenario: invalid month number
    When I run `calrom -m 13`
    Then the exit status should be 1
    And the stderr should contain "not a valid month 13"
    And the stderr should not contain traceback

  Scenario: invalid date
    When I run `calrom 2000-02-31`
    Then the exit status should be 1
    And the stderr should contain "not a valid date 2000-02-31"
    And the stderr should not contain traceback

  Scenario: year too early
    When I run `calrom 1968`
    Then the exit status should be 1
    And the stderr should contain "implemented calendar system in use only since 1970-01-01"
    And the stderr should not contain traceback

  Scenario: unexpected option
    When I run `calrom -k`
    Then the exit status should be 1
    And the stderr should contain "invalid option: -k"
    And the stderr should not contain traceback

  Scenario: unexpected argument
    When I run `calrom 1 2000 3`
    Then the exit status should be 1
    And the stderr should contain "too many arguments"
    And the stderr should not contain traceback
