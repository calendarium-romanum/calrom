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

          puts weekdays

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

      private

      # localizable 2-character weekday shortcuts
      def weekdays
        sunday = Date.new 1987, 10, 25
        sunday
          .upto(sunday + 6)
          .collect {|d| d.strftime('%a')[0..1] }
          .join(' ')
      end
    end
  end
end
