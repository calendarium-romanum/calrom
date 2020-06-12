module Calrom
  module Formatter
    class Overview < Formatter
      def call(calendar, date_range)
        if date_range.is_a? Year
          puts date_range.to_s
          puts
        end

        date_range.each_month do |month|
          puts month
          puts

          puts %w(Su Mo Tu We Th Fr Sa).join(' ')

          print '   ' * month.first.wday
          month.each do |date|
            liturgical_day = calendar[date]

            celebration = liturgical_day.celebrations.first

            datestr = date.day.to_s.rjust(2)
            datestr = highlighter.colour(datestr, celebration.colour)
            datestr = highlighter.rank(datestr, celebration.rank)
            if date == today
              datestr = highlighter.today datestr
            end
            print datestr
            if date.wday == 6
              puts
            else
              print ' '
            end
          end

          puts if month.last.wday != 6 # prevent double blank line
          puts
        end
      end
    end
  end
end
