Feature: Locale selection
  In order to get mostly (language-wise) consistent results
  I want the command to select locale based on the sanctorale metadata and eventual options.

Scenario: default
  When I run `calrom 2000-01-12`
  Then the exit status should be 0
  And the output should contain "Wednesday, 1st week in Ordinary Time"

Scenario: select non-English calendar
  When I run `calrom --calendar=universal-la 2000-01-12`
  Then the exit status should be 0
  And the output should contain "Feria quarta, hebdomada I per annum"

Scenario: multiple calendars specified, the last one's locale wins
  When I run `calrom --calendar=universal-la --calendar=czech-cechy-cs 2000-01-12`
  Then the exit status should be 0
  And the output should contain "Středa 1. týdne v mezidobí"

Scenario: French calendar, English locale, sanctorale celebration
  When I run `calrom --calendar=universal-fr --locale=en 2000-01-03`
  Then the exit status should be 0
  # feast title is from the French sanctorale, rank in the specified locale
  And the output should contain "Saint Nom de Jésus,  optional memorial"

Scenario: French calendar, English locale, temporale celebration
  When I run `calrom --calendar=universal-fr --locale=en 2000-01-12`
  Then the exit status should be 0
  And the output should contain "Wednesday, 1st week in Ordinary Time"

Scenario: specify unsupported locale
  When I run `calrom --locale=xx`
  Then the exit status should be 1
  And the output should contain "Locale 'xx' unsupported"
  And the stderr should not contain traceback

Scenario: sanctorale file with locale metadata
  Given a file named "my_calendar" with:
  """
  ---
  locale: la
  ---
  1/11 : St. None, abbot
  """
  When I run `calrom --calendar=my_calendar 2000-01-11`
  Then the exit status should be 0
  And the output should contain "St. None, abbot,  memoria ad libitum"

Scenario: sanctorale file with no metadata
  Given a file named "my_calendar" with:
  """
  # no YAML front matter here
  1/11 : St. None, abbot
  """
  When I run `calrom --calendar=my_calendar 2000-01-11`
  Then the exit status should be 0
  # default locale is used:
  And the output should contain "St. None, abbot,  optional memorial"


Scenario: sanctorale file with metadata, but without locale entry
  Given a file named "my_calendar" with:
  """
  ---
  notice: no 'locale' entry here
  ---
  1/11 : St. None, abbot
  """
  When I run `calrom --calendar=my_calendar 2000-01-11`
  Then the exit status should be 0
  # default locale is used:
  And the output should contain "St. None, abbot,  optional memorial"
