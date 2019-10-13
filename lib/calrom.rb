require 'calendarium-romanum'
require 'colorized_string'

module Calrom
  CR = CalendariumRomanum
end

require 'calrom/version'
require 'calrom/cli'
require 'calrom/option_parser'
require 'calrom/config'
require 'calrom/date_range'
require 'calrom/formatter/formatter'
require 'calrom/formatter/list'
require 'calrom/formatter/overview'
require 'calrom/highlighter/list'
require 'calrom/highlighter/overview'
