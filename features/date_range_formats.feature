Feature: Date range formats
  In order to conveniently select the date range to display
  I want the command to support a few date range entry formats.

  Scenario: cal-like - year
    When I run `calrom 2000`
    Then the exit status should be 0
    And the output should match /^\s+2000\s+/
    # year is not repeated in every month heading when printing whole year (like `cal`)
    And the output should match /^\s+January\s+February\s+March.+?December/

  Scenario: cal-like - month
    When I run `calrom -m 5`
    Then the exit status should be 0
    And the output should match /^\s+May \d{4}/

  Scenario: cal-like - month with previous year flag
    When current year is 2010 and month 1
    And I run `calrom -m 5p`
    Then the exit status should be 0
    And the output should match /^\s+May 2009\s*$/

  Scenario: cal-like - month with following year flag
    When current year is 2010 and month 1
    And I run `calrom -m 5f`
    Then the exit status should be 0
    And the output should match /^\s+May 2011\s*$/

  Scenario: cal-like - month option and year
    When I run `calrom -m 5 2012`
    Then the exit status should be 0
    And the output should match /^\s+May 2012\s+/

  Scenario: cal-like - month argument and year
    When I run `calrom 5 2012`
    Then the exit status should be 0
    And the output should match /^\s+May 2012\s+/

  Scenario: cal-like - month option, month argument and year
    When I run `calrom -m 4 5 2012`
    Then the exit status should be 0
    # argument wins over the option (like `cal`)
    And the output should match /^\s+May 2012\s+/

  Scenario: ISO date
    When I run `calrom 1992-01-02`
    Then the exit status should be 0
    And the output should match /^1992-01-02\s+/

  Scenario: range of ISO dates
    When I run `calrom 1992-01-02 1992-05-12`
    Then the exit status should be 0
    And the output should match /^\s+January 1992\s+February 1992/

  Scenario: cal-like - -3
    When current year is 2010 and month 1
    And I run `calrom -3`
    Then the exit status should be 0
    And the output should contain "December 2009"
    And the output should contain "January 2010"
    And the output should contain "February 2010"
