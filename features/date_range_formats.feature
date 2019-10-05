Feature: Date range formats
  In order to conveniently select the date range to display
  I want the command to support a few date range entry formats.

  Scenario: cal-like - year
    When I run `calrom 2000`
    Then the exit status should be 0
    And the output should match /^2000\s+/

  Scenario: cal-like - month
    When I run `calrom -m 5`
    Then the exit status should be 0
    And the output should match /^5.\d{4}/

  Scenario: cal-like - month and year
    When I run `calrom -m 5 2012`
    Then the exit status should be 0
    And the output should match /^5.2012\s+/

  Scenario: ISO date
    When I run `calrom 1992-01-02`
    Then the exit status should be 0
    And the output should match /^1992-01-02\s+/

  Scenario: range of ISO dates
