require 'optparse'
require 'pattern-match'

module Calrom
  # Parses command line options, produces Config.
  class OptionParser
    using PatternMatch

    def self.call(argv)
      self.new.call(argv)
    end

    def call(argv)
      config = Config.new

      today = config.today
      year = today.year
      month = today.month
      day = nil
      another_day = nil

      range_type = nil

      opt_parser = ::OptionParser.new do |opts|
        opts.on('-l', '--list', 'list mode') do
          config.formatter = :list
        end

        # cal
        opts.on('-e', '--easter', 'display date of Easter') do
          config.formatter = :easter
        end

        # cal
        opts.on('-m MONTH', '--month=MONTH', 'display the specified month. \'f\' or \'p\' can be appended to display the same month of the following or previous year respectively') do |value|
          range_type = :month
          if value =~ /^(\d+)([pf])$/
            month = $1
            year = validate_year(year) + ($2 == 'f' ? 1 : -1)
          else
            month = value
          end
        end

        # cal
        opts.on('-d YM', '--current-month=YM', 'use given month (YYYY-MM) as the current month (for debugging of date range selection)') do |value|
          year, month = value.split '-'
        end
      end

      arguments = opt_parser.parse argv

      iso_date_regexp = /^(\d{4}-\d{2}-\d{2})$/
      match(arguments) do
        with(_[iso_date_regexp.(date)]) do
          range_type = :day
          day = date
        end

        with(_[iso_date_regexp.(date), iso_date_regexp.(another_date)]) do
          range_type = :free
          day = date
          another_day = another_date
        end

        with(_[y]) do
          range_type ||= :year
          year = y
        end

        with(_[m, y]) do
          range_type = :month
          month, year = m, y
        end

        with([]) {}

        with(_) do
          raise InputError.new('too many arguments')
        end
      end

      config.date_range =
        build_date_range(
          range_type,
          validate_year(year),
          validate_month(month),
          day && validate_day(day),
          another_day && validate_day(another_day)
        )

      config.freeze
    end

    protected

    def validate_year(year)
      unless year.is_a?(Integer) || year =~ /^\d+$/
        raise InputError.new("not a valid year #{year}")
      end

      year.to_i
    end

    def validate_month(month)
      unless month.is_a?(Integer) ||
             (month =~ /^\d+$/ && (1..12).include?(month.to_i))
        raise InputError.new("not a valid month #{month}")
      end

      month.to_i
    end

    def validate_day(day)
      Date.parse(day)
    rescue ArgumentError
      raise InputError.new("not a valid date #{day}")
    end

    def build_date_range(range_type, year, month, day, another_day=nil)
      range =
        case range_type
        when :year
          Year.new(year)
        when :day
          Day.new(day)
        when :free
          DateRange.new(day, another_day)
        else
          Month.new(year, month)
        end

      beginning = CalendariumRomanum::Calendar::EFFECTIVE_FROM
      if range.first < beginning
        raise InputError.new("implemented calendar system in use only since #{beginning}")
      end

      range
    end
  end
end
