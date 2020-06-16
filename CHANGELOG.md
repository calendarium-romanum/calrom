# Changelog

## [0.2.0] 2020-01-14

### Added

- cal-like view (is now default for month, year and date range listing)
- support more cal-like ways of specifying date range
  - month argument `calrom MONTH YEAR` (as an alternative to month option `cal -m MONTH YEAR`)
  - month option with p/f flag `calrom -m 5p` / `calrom -m 5f` as a shortcut to specify a month of the previous/following year
  - option to print the whole current year `calrom -y`
- support arbitrary date range specified as two ISO dates
- input is validated, errors handled and reported
- cal-like option to print (only) the date of Easter
- cal-like debugging options `-d` and `-H`
- option `--[no-]color` to enable/disable ANSI colours (enabled by default)

### Changed

- list view: contains weekday names; month names instead of month numbers

### Fixed

- unhandled edge-case in `Calrom::Month` when dealing with the end of a year
- liturgical colour violet

## [0.1.0] 2019-10-05

### Added

- lists (general Roman) calendar (in English) for the current month
- liturgical colours, celebration rank highlighting
- highlighting of the current day
- date range specification: `cal`-like year and month; single ISO date
