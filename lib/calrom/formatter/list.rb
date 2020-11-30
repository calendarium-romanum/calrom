module Calrom
  module Formatter
    class List < Formatter
      def call(calendar, date_range)
        print_months = date_range.first.month != date_range.last.month

        puts date_range.to_s
        puts

        current_month = nil

        calendar.each_day_in_range(date_range) do |liturgical_day|
          if print_months && liturgical_day.date.month != current_month
            puts unless current_month == nil
            puts liturgical_day.date.strftime('%B') #current_month
            puts

            current_month = liturgical_day.date.month
          end

          day liturgical_day
        end
      end

      private

      def day(liturgical_day)
        liturgical_day.celebrations.each_with_index do |celebration, i|
          s =
            if i > 0
              ' ' * 6
            else
              liturgical_day.date.strftime('%a') +
                liturgical_day.date.day.to_s.rjust(3)
            end
          s += ' '

          colour = celebration.colour
          rank = celebration.rank
          s += highlighter.colour(colour.name[0].upcase, colour) +
               ' ' +
               highlighter.rank(celebration.title, rank) +
               ((rank.short_desc.nil? || rank.sunday? || rank.ferial?) ? '' : ',  ' + rank.short_desc)

          if liturgical_day.date == today
            s = highlighter.today s
          end

          puts s
        end
      end
    end
  end
end
