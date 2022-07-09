require 'icalendar'

module Calrom
  module Formatter
    class Icalendar < Formatter
      def call(calendar, date_range)
        ical = ::Icalendar::Calendar.new

        calendar.each_day_in_range(date_range).each do |day|
          day.celebrations.each do |c|
            ical.event do |e|
              e.dtstart = ::Icalendar::Values::Date.new day.date
              e.summary = c.title
              e.description = "#{c.rank.short_desc}; #{c.colour.name}"
            end
          end
        end

        puts ical.to_ical
      end
    end
  end
end
