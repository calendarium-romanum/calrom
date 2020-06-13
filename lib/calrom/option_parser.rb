require 'optparse'

module Calrom
  # Parses command line options, produces Config.
  class OptionParser
    def self.call(argv)
      self.new.call(argv)
    end

    def call(argv)
      config = Config.new

      today = config.today
      year = today.year
      month = today.month
      day = nil

      range_type = nil

      opt_parser = ::OptionParser.new do |opts|
        opts.on('-l', '--list', 'list mode') do
          config.formatter = :list
        end

        opts.on('-mMONTH', '--month=MONTH', 'which month to list') do |value|
          range_type = :month
          month = value
        end
      end

      arguments = opt_parser.parse argv

      if arguments.size > 0
        arg = arguments[0]
        if arg =~ /^\d{4}-\d{2}-\d{2}$/
          range_type = :day
          day = arg
        elsif arguments.size == 2
          range_type = :month
          month, year = arguments
        else
          range_type ||= :year
          year = arg
        end
      end

      config.date_range =
        build_date_range(
          range_type,
          validate_year(year),
          validate_month(month),
          day && validate_day(day)
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

    def build_date_range(range_type, year, month, day)
      range =
        if range_type == :year
          Year.new(year)
        elsif range_type == :day
          Day.new(day)
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
