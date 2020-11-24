Feature: Filtering
  In order to allow obtaining just a subset of days and celebrations
  I want the command to support filtering options

Scenario: Filter days
  When I run `calrom --filter-days="date.day != 1" -l 2000-01-01`
  Then the exit status should be 0
  And the output should not contain "Mary"

Scenario: Filter days by multiple expressions
  When I run `calrom --filter-days="date.day == 1" --filter-days="celebrations[0].rank > CR::Ranks::MEMORIAL_GENERAL" -l 2000`
  Then the exit status should be 0
  And the output should have 22 lines
  And the output should contain "Mary"
  And the output should contain "Ascension"

Scenario: Filter celebrations
  When I run `calrom --filter-celebrations="ferial?" -l 2000-01-13`
  Then the exit status should be 0
  And the output should match /Thursday.+?in Ordinary Time/
  And the output should not contain "Hilary"

Scenario: Filter celebrations by multiple expressions
  When I run `calrom --filter-celebrations="ferial?" --filter-celebrations="cycle == :temporale" -l 2000-01-13`
  Then the exit status should be 0
  And the output should match /Thursday.+?in Ordinary Time/
  And the output should not contain "Hilary"
