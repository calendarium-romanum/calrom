Feature: Temporale options
  In order to be able to configure Temporale settings
  I want the command to accept a set of appropriate options

Scenario: Transfer solemnity to Sunday
  When I run `calrom --to-sunday=epiphany 2000-01-02`
  Then the exit status should be 0
  And the output should contain "The Epiphany"

Scenario: Invalid solemnity for transfer
  When I run `calrom --to-sunday=unexpected`
  Then the exit status should be 1
  And the output should contain "invalid argument: --to-sunday=unexpected"
  And the stderr should not contain traceback
