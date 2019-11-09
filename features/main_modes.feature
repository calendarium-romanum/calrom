Feature: Main modes
  In order to effectively find liturgical calendar information
  As someone who needs such information
  I want to be able to select between several calendar display modes

  Scenario: Run with zero configuration
    When I run `calrom`
    Then the exit status should be 0

  Scenario: Run in overview mode
    When I run `calrom`
    Then the exit status should be 0
    And the output should contain "Su Mo Tu We Th Fr Sa"

  Scenario: Run in detailed listing mode
    When I run `calrom -l`
    Then the exit status should be 0
    # there are some days
    And the output should contain "1 "
    And the output should contain "29 "
    # there are some saints, in English
    And the output should contain "Saint"
    # there are some ranks
    And the output should contain "ferial"
    And the output should contain "memorial"
