Feature: Filtering
  In order to allow obtaining just a subset of days and celebrations
  I want the command to support filtering options

Scenario: Filter days
  When I run `calrom --day-filter="date.day != 1" -l 2000-01-01`
  Then the exit status should be 0
  And the output should not contain "Mary"

Scenario: Filter days by multiple expressions
  When I run `calrom --day-filter="date.day == 1" --day-filter="celebrations[0].rank > CR::Ranks::MEMORIAL_GENERAL" -l 2000`
  Then the exit status should be 0
  And the output should have 22 lines
  And the output should contain "Mary"
  And the output should contain "Ascension"

Scenario: Filter celebrations
  When I run `calrom --celebration-filter="ferial?" -l 2000-01-13`
  Then the exit status should be 0
  And the output should match /Thursday.+?in Ordinary Time/
  And the output should not contain "Hilary"

Scenario: Filter celebrations by multiple expressions
  When I run `calrom --celebration-filter="ferial?" --celebration-filter="cycle == :temporale" -l 2000-01-13`
  Then the exit status should be 0
  And the output should match /Thursday.+?in Ordinary Time/
  And the output should not contain "Hilary"

Scenario: Filter expression raising an exception
  When I run `calrom --day-filter="1/0"`
  Then the exit status should be 1
  And the output should contain "Filter expression '1/0' raised ZeroDivisionError: divided by 0"
  And the stderr should not contain traceback

Scenario: Easily use calendarium-romanum constants
  # demonstrates that calendarium-romanum constants for celebration ranks, colours and seasons
  # are included in the expressions' context and it's not necessary to use qualifiers
  # like CR::Ranks::FERIAL or Ranks::FERIAL
  When I run `calrom --celebration-filter="rank != FERIAL && colour == RED" --day-filter="season == LENT"`
  Then the exit status should be 0
