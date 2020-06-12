require 'optparse'

module Calrom
  # Parses command line options, produces Config.
  class OptionParser
    def self.call(argv)
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
          month = value.to_i
        end
      end

      arguments = opt_parser.parse argv

      if arguments.size > 0
        arg = arguments[0]
        if arg =~ /^\d{4}-\d{2}-\d{2}$/
          range_type = :day
          day = arg
        else
          range_type ||= :year
          year = arg.to_i
        end
      end

      config.date_range =
        if range_type == :year
          Year.new(year)
        elsif range_type == :day
          Day.new(Date.parse(day))
        else
          Month.new(year, month)
        end

      config.freeze
    end
  end
end
