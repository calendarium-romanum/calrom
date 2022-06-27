# Changelog

## [0.4.0] 2022-06-27

### Added

- date range selection: cal-like option `-3` to select the current month together
  with the preceding and following one (contributed by Fabio Soares @fabiosoaresv)
- if exactly one sanctorale data file is specified and its YAML front matter
  references a parent calendar (key `extends`), the file is loaded with its complete
  graph of parents
- option `--[no-]load-parents` to explicitly enable/disable loading of parent calendars
- basic support for remote calendars: the `--calendar=` option now accepts
  also a calendar API URL like
  `--calendar=http://calapi.inadiutorium.cz/api/v0/en/calendars/general-la`,
  the referenced API is expected to be compatible with
  [Liturgical Calendar API](http://calapi.inadiutorium.cz/) v0
- calendar listing (`--calendars`) marks default calendar as such
- calendar listing lists each calendar's parents
- option `--verbose`
- condensed view (`--format=condensed`), intended for use cases like printing current day
  in a window manager toolbar and the like
- option `--to-sunday=` to configure which temporale solemnities should be transferred to Sunday
  (e.g. `--to-sunday=epiphany`)
- option `--temporale-extension=` to activate temporale extension
  (supported values are [temporale extension](https://github.com/igneus/calendarium-romanum/tree/master/lib/calendarium-romanum/temporale/extensions)
  class names, e.g. `--temporale-extension=ChristEternalPriest`)
- any class in the `Calrom::Formatter` module is considered formatter and its
  lowercased name can be used as value for the `--format=` option - custom formatters
  can be added by defining new classes in the namespace
- options `--day-filter=` and `--celebration-filter=` for filtering days and celebrations
  by a Ruby expression
- environment variable `CALROM_CURRENT_DATE` can be used to override current date
  (intended mainly for testing)

### Changed

- automated locale selection based on sanctorale data file relies solely on the `locale` key
  of the file's YAML front matter (previously it relied on a file naming convention)
- option `--calendar=` expands tilde in path (if it isn't expanded by shell,
  as is the case e.g. in configuration files)
- when displaying just a single day, highlighting of the current day is disabled by default
  (i.e. if the day being displayed is current day, it won't be highlighted as such)
- list view (`--list`): rank is not printed for ferials and Sundays
- overview view always arranges the displayed months in multiple columns, just like `cal`
  (previously date ranges spanning less than three months were printed in a single column)
- date range specification: support for dates with year higher than 9999 (e.g. `10000-01-01`)

### Fixed

- crash on invalid value of `--locale`
- list view: when printing a date range between the same months of different years
  (e.g. 2000-01-xx .. 2001-01-xx), year was not printed in month headings

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
