Feature: Machine-readable output formats
  In order to be able to process calendar data by further applications
  I want the command to support output in a few machine-readable formats

  Scenario: CSV
    When I run `calrom --format=csv 2001-02-24`
    Then the exit status should be 0
    And the output should contain:
    """
    date,title,symbol,rank,rank_num,colour,season
    2001-02-24,"Saturday, 7th week in Ordinary Time",,ferial,3.13,green,ordinary
    2001-02-24,The Memorial of the Blessed Virgin Mary on Saturday,saturday_memorial_bvm,optional memorial,3.12,white,ordinary
    """

  Scenario: JSON single day
    When I run `calrom --format=json 2001-02-24`
    Then the exit status should be 0
    And the output should contain:
    """
    [{"date":"2001-02-24","season":"ordinary","season_week":7,"celebrations":[{"title":"Saturday, 7th week in Ordinary Time","symbol":null,"colour":"green","rank":"ferial","rank_num":3.13},{"title":"The Memorial of the Blessed Virgin Mary on Saturday","symbol":"saturday_memorial_bvm","colour":"white","rank":"optional memorial","rank_num":3.12}],"weekday":"Saturday"}]
    """

  Scenario: JSON multiple days
    When I run `calrom --format=json 2001-02-12 2001-02-13`
    Then the exit status should be 0
    And the output should contain:
    """
    [{"date":"2001-02-12","season":"ordinary","season_week":6,"celebrations":[{"title":"Monday, 6th week in Ordinary Time","symbol":null,"colour":"green","rank":"ferial","rank_num":3.13}],"weekday":"Monday"},
    {"date":"2001-02-13","season":"ordinary","season_week":6,"celebrations":[{"title":"Tuesday, 6th week in Ordinary Time","symbol":null,"colour":"green","rank":"ferial","rank_num":3.13}],"weekday":"Tuesday"}]
    """

  Scenario: iCalendar
    When I run `calrom --format=ical 2001-02-24`
    Then the exit status should be 0
    # TODO: it would be desirable to specify larger portions of the expected output,
    #   but it's not obvious how to enter CRLF-style ("\r\n") EOL in Gherkin
    And the output should contain:
    """
    SUMMARY:Saturday\, 7th week in Ordinary Time
    """
    And the output should contain:
    """
    SUMMARY:The Memorial of the Blessed Virgin Mary on Saturday
    """
