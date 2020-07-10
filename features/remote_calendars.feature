Feature: Remote calendars
  In order to be able to query remote calendars
  I want the command to support the liturgical calendar API.

  Scenario: successful query
    When I run `calrom --calendar=http://calapi.inadiutorium.cz/api/v0/en/calendars/general-la 2001-01-02`
    Then the exit status should be 0
    And the output should contain "Basilii et Gregorii Nazianzeni"

  Scenario: unexpected status
    When I run `calrom --calendar=http://calapi.inadiutorium.cz/api/v0/en/calendars/unknown 2001-01-02`
    Then the exit status should be 1
    And the stderr should contain "Remote calendar query failed: Unexpected HTTP status 400"
    And the stderr should not contain traceback

  Scenario: attempt calendar layering
    When I run `calrom --calendar=universal-en --calendar=http://calapi.inadiutorium.cz/api/v0/en/calendars/unknown 2001-01-02`
    Then the exit status should be 1
    And the stderr should contain "--calendar option provided multiple times, but at least one of the calendars is remote."
    And the stderr should contain "Remote calendars cannot be layered."
    And the stderr should not contain traceback

  Scenario: attempt calendar layering (reversed option order)
    When I run `calrom --calendar=http://calapi.inadiutorium.cz/api/v0/en/calendars/unknown --calendar=universal-en 2001-01-02`
    Then the exit status should be 1
    And the stderr should contain "--calendar option provided multiple times, but at least one of the calendars is remote."
    And the stderr should contain "Remote calendars cannot be layered."
    And the stderr should not contain traceback
