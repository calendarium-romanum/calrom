module Calrom
  module Formatter
    class List < Formatter
      def call(days)
        days.each do |liturgical_day|
          day liturgical_day
        end
      end

      private

      def day(liturgical_day)
        liturgical_day.celebrations.each_with_index do |celebration, i|
          if i > 0
            print ' ' * 3
          else
            print liturgical_day.date.day.to_s.rjust(3)
          end
          print ' '

          colour = celebration.colour
          rank = celebration.rank
          print highlighter.colour(colour.name[0].upcase, colour)
          print ' '
          print highlighter.rank(celebration.title, rank)
          print ',  '
          print rank.short_desc
          puts
        end
      end
    end
  end
end
