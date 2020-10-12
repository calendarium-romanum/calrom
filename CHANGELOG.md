# Changelog

### Next features

- added option -3 to list the previous, current and next month surrounding today

## [0.3.0] 2020-06-21

### Added

- date range selection: options `--today`, `--tomorrow`, `--yesterday`
- specifying the `--calendar=` option multiple times layers the calendars
- file path can be provided as argument to the `--calendar=` option
- option `--locale=` to specify language of localized calendar strings
- language of the (last loaded) sanctorale data is by default used for localized strings
- output is by default not colorized when not printing to a terminal
- configuration files
  - `/etc/calromrc`
  - `$HOME/.calromrc`
  - specified by the `--config=` option
- machine-readable output formats `--format=csv`, `--format=json`
- option `--calendars` to list bundled calendars

### Fixed

- crash on option parsing errors other than invalid option

## [0.2.0] 2020-06-16

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
