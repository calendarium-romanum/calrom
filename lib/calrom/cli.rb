require 'optparse'

module Calrom
  class CLI
    CR = CalendariumRomanum

    def self.call(argv)
      today = Date.today
      calendar = CR::PerpetualCalendar.new(sanctorale: CR::Data::GENERAL_ROMAN_ENGLISH.load)

      year = today.year
      month = today.month

      range_type = nil

      opt_parser = OptionParser.new do |opts|
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

      range =
        if range_type == :year
          puts year
          CR::Util::Year.new(year)
        else
          puts "#{month}/#{year}"
          CR::Util::Month.new(year, month)
        end

      puts

      range.each do |date|
        litday = calendar[date]
        litday.celebrations.each_with_index do |celebration, i|
          if i > 0
            print ' ' * 3
          else
            print date.day.to_s.rjust(3)
          end

          print ' '
          print celebration.colour.name[0].upcase
          print ' '
          print celebration.title
          print ',  '
          print celebration.rank.short_desc
          puts
        end
      end
    end
  end
end
