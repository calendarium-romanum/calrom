require 'set'
require 'stringio'

module Calrom
  module Formatter
    class Overview < Formatter
      def call(calendar, date_range)
        colnum = 3 # TODO: expose configuration
        if date_range.is_a? Year
          puts center_on(weekdays.size * colnum + 2 * (colnum - 1), date_range.to_s)
        end

        date_range.each_month.each_slice(colnum) do |months|
          columns = months.collect do |month|
            StringIO.new.tap do |io|
              print_month io, calendar, month, date_range.is_a?(Year)
            end
          end
          print_columns columns, @io
        end
      end

      private

      def print_month(io, calendar, month, year_in_heading)
        heading = month.first.strftime(year_in_heading ? '%B' : '%B %Y')
        io.puts center_on weekdays.size, heading

        io.puts weekdays

        io.print '   ' * month.first.wday
        calendar.each_day_in_range(month, include_skipped: true) do |liturgical_day|
          date = liturgical_day.date

          if liturgical_day.skipped?
            datestr = '  '
          else
            celebration = liturgical_day.celebrations.first

            datestr = date.day.to_s.rjust(2)
            datestr = highlighter.colour(datestr, celebration.colour)
            datestr = highlighter.rank(datestr, celebration.rank)
          end

          if date == today
            datestr = highlighter.today datestr
          end
          io.print datestr
          if date.wday == 6
            io.puts
          else
            io.print ' '
          end
        end
      end

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

      def print_columns(columns, io)
        line_enumerators = columns.collect {|c| c.string.each_line }
        not_yet_exhausted = Set.new line_enumerators
        column_width = weekdays.size

        loop do
          break if not_yet_exhausted.empty?

          line_enumerators.each do |l|
            begin
              line = l.next.chop
              io.print line
              io.print ' ' * (column_width - colour_aware_size(line))
            rescue StopIteration
              io.print ' ' * column_width
              not_yet_exhausted.delete l
            end
            io.print '  '
          end
          io.puts
        end
      end

      # String length ignoring colour codes
      def colour_aware_size(str)
        ColorizedString.new(str).uncolorize.size
      end
    end
  end
end
