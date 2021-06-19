# calrom

[![Build Status](https://travis-ci.org/calendarium-romanum/calrom.svg?branch=master)](https://travis-ci.org/calendarium-romanum/calrom)
[![Gem Version](https://badge.fury.io/rb/calrom.svg)](https://badge.fury.io/rb/calrom)

Command line utility providing access to the Roman Catholic
liturgical calendar (post-Vatican II).

Built on top of the [calendarium-romanum][caro] Ruby gem.

## Installation

calrom is a Ruby gem:

`$ gem install calrom`

## Usage

### Specifying date range

Print liturgical calendar for the current month (default):

`$ calrom`

... for a specified month of the current year:

`$ calrom -m 9`

... for a specified month of another year:

`$ calrom -m 1 2028` or `$ calrom 1 2028`

... for a whole year:

`$ calrom 2017`

... for the current year:

`$ calrom -y`

... for a specified date:

`$ calrom 2028-01-15`

... for an arbitrary date range:

`$ calrom 2028-01-15 2028-03-07`

### Selecting calendar

There are a few calendars bundled in calrom (actually in the calendarium-romanum gem)
and ready to use. List them:

`$ calrom --calendars`

Each entry of the listing contains an ID of the calendar, it's name and language code.
Use calendar ID to request General Roman Calendar in Latin:

`$ calrom --calendar=universal-la`

You can prepare [your own calendar data][carodata] and load them:

`$ calrom --calendar=path/to/my_calendar.txt`

If you specify more than one calendar, they are loaded "layered" one over another
(from left to right), which comes in handy when extending a general calendar
with just a few additional and/or differing celebrations, e.g. solemnities (titular, dedication)
of the local church:

`$ calrom --calendar=universal-la --calendar=path/to/our_local_celebrations.txt`

### Data presentation settings

Print detailed listing:

`$ calrom -l`

Print current day in a condensed format (intended mainly for use cases like
window manager toolbars):

`$ calrom --format=condensed --today`

Disable colours:

`$ calrom --no-color`

Machine-readable output formats:

`$ calrom --format=json` - prints JSON array containing one object per day.
The object contents mimick output of the [Church Calendar API v0][calapidoc].

`$ calrom --format=csv` - prints a CSV, one celebration per line
(i.e. there is one or more lines for each liturgical day).

### Configuration files

`calrom` looks for configuration files `/etc/calromrc` and `~/.calromrc`.
They are processed in this order and both are used if available.
Their syntax is that of shell options and arguments (with the sole exception that newline
is not considered end of shell input, but generic whitespace), supported are all options and arguments
accepted by the command.
It usually makes sense to use configuration files only for the most fundamental settings
you will never change, like selecting calendar (if you know you will always check this single one)
or disabling colours (if you hate colourful output).

If a custom configuration file location is specified on the command line,
`$ calrom --config=path/to/my/custom/config`, the standard system-wide and user-specific configuration
files are *not* loaded. Empty config path `$ calrom --config=` makes calrom ignore all configuration
files and use the built-in default configuration.

Example configuration file, loading the proper calendar of the archdiocese of Prague
and disabling colours:

```bash
# shell-like comments can be used in configuration files

--calendar=czech-praha-cs # calendar of the archdiocese of Prague
--calendar=~/calendar_data/local_church.txt # path to a custom calendar file with proper celebrations of the parish where I live (titular feast of the church, dedication)

--load-parents # load also parent calendars specified by the calendar file(s)
               # (default if just one calendar file is specified, but we specified two)

--no-color # disable colours
```

(Configuration file format is inspired by [.rspec][dotrspec], [.yardopts][dotyardopts]
and others.)

## Running tests

Clone the repository, `$ bundle install` to install dependencies, then:

`$ rake cucumber` - run specs describing the command line interface

`$ rake spec` - run specs describing internal implementation details

`$ rake` - run all groups of specs one after another

## Project roadmap

* [x] detailed listing of a day/month/year/range of dates
* [x] month/year overview - options and output mostly mimicking
  the BSD Unix [`cal`][cal] utility,
  but with liturgical colours and celebration ranks
* [x] condensed format (but with detailed information) suitable for awesome/i3 toolbars etc.
* [x] machine-readable detailed listing
* [ ] year summary: lectionary cycles, movable feasts
* [x] configuration file to set default options
* [x] specify calendar data path (with support for layering several calendars)
* [ ] option to auto-select one of optional celebrations - with multiple supported strategies (prefer ferial, take first non-ferial, configured whitelist, blacklist)
* [ ] integrate online data sources

## Backward compatibility

Project adheres to [semantic versioning][semver]
with regard to the command line interface:
between major releases,
the same configuration (through command line options and other
ways of configuration the application will eventually support)
should print information of the same (or greater) level of detail
for the same range of dates.
For output formats explicitly documented as machine-readable,
format must be preserved (where some machine-readable
formats, especially the structured ones, allow backward-compatible
extensions, others do not, according to their nature).

No backward compatibility is guaranteed on the level of the application's
internal interfaces, since they are not intended to be used
by third-party code.

## CLI patterns

When designing new elements (options, arguments) of the
command line interface

* [(BSD version of) `cal`][cal] should be mimicked where reasonable
* the [Command-Line Options][taoup] chapter from E. S. Raymond's
  *The Art of Unix Programming* should be consulted in the rest
  of cases

## License

GNU/GPL 3.0 or later

[caro]: https://github.com/igneus/calendarium-romanum
[carodata]: https://github.com/igneus/calendarium-romanum/tree/master/data
[calapidoc]: http://calapi.inadiutorium.cz/api-doc
[semver]: https://semver.org/
[cal]: https://www.freebsd.org/cgi/man.cgi?query=cal
[taoup]: http://www.catb.org/esr/writings/taoup/html/ch10s05.html
[dotrspec]: https://relishapp.com/rspec/rspec-core/v/2-0/docs/configuration/read-command-line-configuration-options-from-files
[dotyardopts]: https://rubydoc.info/gems/yard/file/docs/GettingStarted.md#yardopts-options-file
