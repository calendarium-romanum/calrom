Feature: Date range formats
  In order to conveniently select the date range to display
  I want the command to support a few date range entry formats.

  Scenario: cal-like - year
    When I run `calrom 2000`
    Then the exit status should be 0
    And the output should match /^2000\s+/
    # year is not repeated in every month heading when printing whole year (like `cal`)
    And the output should match /^\s+January$.+?^\s+December$/

  Scenario: cal-like - month
    When I run `calrom -m 5`
    Then the exit status should be 0
    And the output should match /^\s+May \d{4}/

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
