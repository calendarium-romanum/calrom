Feature: Machine-readable output formats
  In order to be able to process calendar data by further applications
  I want the command to support output in a few machine-readable formats

  Scenario: CSV
    When I run `calrom --format=csv 2001-02-24`
    Then the exit status should be 0
    And the output should contain:
    """
    date,title,rank,rank_num,colour,season
    2001-02-24,"Saturday, 7th week in Ordinary Time",ferial,3.13,green,ordinary
    2001-02-24,The Memorial of the Blessed Virgin Mary on Saturday,optional memorial,3.12,white,ordinary
    """
