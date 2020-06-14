Feature: Colours
  In order to communicate information (liturgical colours, ranks) on a limited space
  I want the command to produce colorized output.

  Scenario: Explicitly enable colours
    When I run `calrom --color`
    Then the exit status should be 0
    And the output should contain some colour codes

  Scenario: Explicitly disable colours
    When I run `calrom --no-color`
    Then the exit status should be 0
    And the output should contain no colour codes
