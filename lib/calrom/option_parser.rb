require 'optparse'

module Calrom
  # Parses command line options, produces Config.
  class OptionParser
    def self.call(argv)
      config = Config.new

      today = config.today
      year = today.year
      month = today.month

      range_type = nil

      opt_parser = ::OptionParser.new do |opts|
        # for now does nothing, is default
        opts.on('-l', '--list', 'list mode')

        opts.on('-mMONTH', '--month=MONTH', 'which month to list') do |value|
          range_type = :month
          month = value.to_i
        end
      end

      arguments = opt_parser.parse argv

      if arguments.size > 0
        year = arguments[0].to_i
        range_type ||= :year
      end

      config.date_range =
        if range_type == :year
          puts year
          CR::Util::Year.new(year)
        else
          puts "#{month}/#{year}"
          CR::Util::Month.new(year, month)
        end

      config.freeze
    end
  end
end
