module Calrom
  module Formatter
    # Prints (only) date of Easter for the specified year.
    class Easter
      def call(calendar, date_range)
        unless date_range.is_a?(Year) || date_range.is_a?(Month)
          raise 'unexpected date range, expected a year'
        end

        puts CR::Temporale::Dates
               .easter_sunday(date_range.first.year - 1)
               .strftime('%D')
      end
    end
  end
end
