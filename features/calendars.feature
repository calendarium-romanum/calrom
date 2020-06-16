Feature: Calendars
  In order to be able to check calendars both bundled and custom
  I want the command to provide ways to list available calendars
  And to specify which calendar to use
  And to set calendar options.

  Scenario: list bundled calendars
    When I run `calrom --calendars`
    Then the exit status should be 0
    And the output should match /universal-en\s*:\s*General Roman Calendar\s+\[en\]/

  Scenario: specify bundled calendar by it's siglum
    When I run `calrom --calendar=universal-la 2001-01-02`
    Then the exit status should be 0
    And the output should contain "Basilii et Gregorii Nazianzeni"
