Feature: Configuration file
  In order to be able to set frequently (or always) repeated configuration only once
  I want the command to be configurable through configuration file(s)

  # So far I haven't found a way to test the system-wide config.

  Scenario: user config
    And a file named "~/.calromrc" with:
    """
    --calendar=universal-la
    """
    When I run `calrom 2001-01-02`
    Then the exit status should be 0
    And the output should contain "Basilii et Gregorii Nazianzeni"
