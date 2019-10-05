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
          s =
            if i > 0
              ' ' * 3
            else
              liturgical_day.date.day.to_s.rjust(3)
            end
          s += ' '

          colour = celebration.colour
          rank = celebration.rank
          s += highlighter.colour(colour.name[0].upcase, colour) +
               ' ' +
               highlighter.rank(celebration.title, rank) +
               (rank.short_desc.nil? ? '' : ',  ' + rank.short_desc)

          if liturgical_day.date == today
            s = highlighter.today s
          end

          puts s
        end
      end
    end
  end
end
