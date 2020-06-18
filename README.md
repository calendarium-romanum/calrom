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

### Data presentation settings

Print detailed listing:

`$ calrom -l`

Disable colours:

`$ calrom --no-color`

### Configuration files

`calrom` looks for configuration files `/etc/calromrc` and `~/.calromrc`.
They are processed in this order and both are used if available.
Their syntax is that of shell options and arguments (with the sole exception that newline
is not considered end of shell input, but generic whitespace), supported are all options and arguments
accepted by the command.
It usually makes sense to use configuration files only for the most fundamental settings
you will never change, like selecting calendar (if you know you will always check this single one)
or disabling colours (if you hate colourful output).

Example configuration loading the proper calendar of the archdiocese of Prague
and disabling colours:

```
--calendar=czech-cs
--calendar=czech-cechy-cs
--calendar=czech-praha-cs
--no-color
```

(Configuration file format is inspired by [.rspec][dotrspec].)

## Running tests

Clone the repository, `$ bundle install` to install dependencies, then:

`$ rake cucumber` - run specs describing the command line interface

`$ rake spec` - run specs describing internal implementation details

`$ rake` - run all groups of specs one after another

## Project roadmap

* [x] detailed listing of a day/month/year/range of dates
* [ ] month/year overview - options and output mostly mimicking the
  the BSD Unix [`cal`][cal] utility,
  but with liturgical colours and celebration ranks
* [ ] condensed format (but with detailed information) suitable for awesome/i3 toolbars etc.
* [ ] machine-readable detailed listing
* [ ] year summary: lectionary cycles, movable feasts
* [x] configuration file to set default options
* [ ] specify calendar data path (with support for layering several calendars)
* [ ] option to auto-select one of optional celebrations - with multiple supported strategies (prefer ferial, take first non-ferial, configured whitelist, blacklist)
* [ ] integrate online data sources
* [ ] interactive browsing

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
  "The Art of Unix Programming" should be consulted in the rest
  of cases

## License

GNU/GPL 3.0 or later

[caro]: https://github.com/igneus/calendarium-romanum
[semver]: https://semver.org/
[cal]: https://www.freebsd.org/cgi/man.cgi?query=cal
[taoup]: http://www.catb.org/esr/writings/taoup/html/ch10s05.html
[dotrspec]: https://relishapp.com/rspec/rspec-core/v/2-0/docs/configuration/read-command-line-configuration-options-from-files
