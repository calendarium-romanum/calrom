require 'csv'

module Calrom
  module Formatter
    class Csv
      def call(calendar, date_range)
        CSV do |out|
          out << %w(date title symbol rank rank_num colour season)

          date_range.each do |date|
            day = calendar[date]
            day.celebrations.each do |c|
              out << [
                day.date,
                c.title,
                c.symbol,
                c.rank.short_desc,
                c.rank.priority,
                c.colour.symbol,
                day.season.symbol
              ]
            end
          end
        end
      end
    end
  end
end
