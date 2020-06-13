module Calrom
  module Formatter
    class Overview < Formatter
      def call(calendar, date_range)
        if date_range.is_a? Year
          puts date_range.to_s
          puts
        end

        date_range.each_month do |month|
          heading = month.first.strftime(date_range.is_a?(Year) ? '%B' : '%B %Y')
          puts center_on weekdays.size, heading

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
        @weekdays ||=
          begin
            sunday = Date.new 1987, 10, 25
            sunday
              .upto(sunday + 6)
              .collect {|d| d.strftime('%a')[0..1] }
              .join(' ')
          end
      end

      # centers given string on a given line length
      def center_on(line_length, content)
        (' ' * (line_length / 2 - content.size / 2)) +
          content
      end
    end
  end
end
