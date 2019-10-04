module Calrom
  class CLI
    CR = CalendariumRomanum

    def self.call(argv)
      today = Date.today
      calendar = CR::Calendar.for_day(today, CR::Data::GENERAL_ROMAN_ENGLISH.load)

      puts "#{today.month}/#{today.year}"
      puts

      CR::Util::Month.new(today.year, today.month).each do |date|
        litday = calendar[date]
        litday.celebrations.each_with_index do |celebration, i|
          if i > 0
            print ' ' * 3
          else
            print date.day.to_s.rjust(3)
          end

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
