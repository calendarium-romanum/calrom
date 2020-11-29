Feature: Main modes
  In order to effectively find liturgical calendar information
  As someone who needs such information
  I want to be able to select between several calendar display modes

  Scenario: Run with zero configuration - overview mode
    When I run `calrom`
    Then the exit status should be 0
    And the output should contain "Su Mo Tu We Th Fr Sa"

  Scenario: Run in detailed listing mode
    When I run `calrom -l`
    Then the exit status should be 0
    And the output should contain 29 to 31 day entries
    And the output should mention some feasts of saints

  Scenario: For a single day use detailed listing mode by default
    When I run `calrom 2000-01-01`
    Then the exit status should be 0
    And the output should contain 1 to 1 day entries

  Scenario: Condensed mode
    When I run `calrom --format=condensed 2000-01-06`
    Then the exit status should be 0
    And the output should contain "The Epiphany *W"

  Scenario: date of Easter
    When I run `calrom -e 2000`
    Then the exit status should be 0
    And the output should contain exactly "04/23/00"
