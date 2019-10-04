module Calrom
  class CLI
    def self.call(argv)
      config = OptionParser.call argv
      calendar = config.calendar

      puts

      config.date_range.each do |date|
        calendar[date].celebrations.each_with_index do |celebration, i|
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
