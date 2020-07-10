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
