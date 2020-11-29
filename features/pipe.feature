Feature: Pipe support
  In order to ensure interoperability with standard Unix tools
  I want the command to handle pipe-related signals sanely.

Scenario: Pipe broken
  # aruba does not support shell pipe in normal "When I run" step, so we wrap the call in bash
  When I run `bash -e -c "calrom --list --year | head --lines=5"`
  Then the exit status should be 0
  And the stderr should not contain traceback
  And the stderr should not contain "Broken pipe"
