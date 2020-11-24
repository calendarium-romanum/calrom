require 'json'

module Calrom
  module Formatter
    # JSON format mimicking Church Calendar API v0 (https://github.com/igneus/church-calendar-api)
    class Json < Formatter
      def call(calendar, date_range)
        # We build the outer JSON Array manually in order to be able to print
        # vast amounts of calendar data without risking RAM exhaustion.
        print "["

        calendar.each_day_in_range(date_range).each_with_index do |day,i|
          date = day.date
          hash = {
            date: date,
            season: day.season.symbol,
            season_week: day.season_week,
            celebrations: day.celebrations.collect do |c|
              {
                title: c.title,
                symbol: c.symbol,
                colour: c.colour.symbol,
                rank: c.rank.short_desc,
                rank_num: c.rank.priority
              }
            end,
            weekday: date.strftime('%A'),
          }

          puts "," if i > 0
          print JSON.generate hash
        end

        puts "]"
      end
    end
  end
end
