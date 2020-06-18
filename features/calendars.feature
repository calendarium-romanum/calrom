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

  Scenario: specify calendar by file path
    Given a file named "my_calendar" with:
    """
    1/11 : St. None, abbot
    """
    When I run `calrom --calendar=my_calendar 2000-01-11`
    Then the exit status should be 0
    And the output should contain "St. None, abbot,  optional memorial"

  Scenario: read calendar from the standard input
    Given a file named "my_calendar" with:
    """
    1/11 : St. None, abbot
    """
    When I run the following commands:
    """
    cat my_calendar | calrom --calendar=- 2000-01-11
    """
    Then the exit status should be 0
    And the output should contain "St. None, abbot,  optional memorial"

  Scenario: calendar file name the same as siglum of a bundled calendar
    Given a file named "universal-en" with:
    """
    1/11 : St. None, abbot
    """
    When I run `calrom --calendar=universal-en 2000-01-11`
    Then the exit status should be 0
    # in case of name conflict, local file wins over a bundled calendar
    And the output should contain "St. None, abbot,  optional memorial"

  Scenario: specify unknown calendar
    When I run `calrom --calendar=unknown 2000-01-11`
    Then the exit status should be 1
    And the stderr should contain "neither a file, nor a valid identifier of a bundled calendar."
    And the stderr should not contain traceback
