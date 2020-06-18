Feature: Configuration file
  In order to be able to set frequently (or always) repeated configuration only once
  I want the command to be configurable through configuration file(s)

  # So far I haven't found a way to test the system-wide config.

  Scenario: user config
    Given a file named "~/.calromrc" with:
    """
    --calendar=universal-la
    """
    When I run `calrom 2001-01-02`
    Then the exit status should be 0
    And the output should contain "Basilii et Gregorii Nazianzeni"

  Scenario: config supports shell-like comments
    Given a file named "~/.calromrc" with:
    """
    --calendar=universal-la # --color
    # --calendar=universal-fr
    """
    When I run `calrom 2001-01-02`
    #Then the exit status should be 0
    And the output should contain "Basilii et Gregorii Nazianzeni"
    And the output should contain no colour codes

  Scenario: config specified by an option
    Given a file named "~/.calromrc" with:
    """
    --calendar=universal-la
    --color
    """
    And a file named "custom_config.txt" with:
    """
    --calendar=universal-fr
    """
    When I run `calrom --config=custom_config.txt 2001-01-02`
    Then the exit status should be 0
    And the output should contain "Saints Basile le Grand et Grégoire de Naziance"
    # This last expectation checks that ~/.calromrc was not loaded at all
    And the output should contain no colour codes

  Scenario: disable config files by an option
    Given a file named "~/.calromrc" with:
    """
    --calendar=universal-la
    """
    When I run `calrom --config= 2001-01-02`
    Then the exit status should be 0
    # config file was not loaded, default calendar was used
    And the output should contain "Saints Basil the Great and Gregory Nazianzen"

  Scenario: config specified by an option does not exist
    When I run `calrom --config=unknown_file`
    Then the exit status should be 1
    And the stderr should contain "not found"
    And the stderr should not contain traceback
