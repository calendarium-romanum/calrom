module Calrom
  module Formatter
    class List
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
