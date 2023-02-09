module Calrom
  module Formatter
    class Condensed < Formatter
      def call(calendar, date_range)
        calendar.each_day_in_range(date_range) {|d| day d }
      end

      private

      def day(liturgical_day)
        c = liturgical_day.celebrations.first

        colour = highlighter.colour(c.colour.name[0].upcase, c.colour)
        rank = highlighter.rank(rank(c.rank), c.rank)
        title = short_title c
        more = additional_celebrations(liturgical_day) + vespers(liturgical_day)

        puts "#{rank}#{title} #{colour}#{more}"
      end

      def rank(rank)
        if rank.solemnity?
          '*'
        elsif rank.feast?
          '+'
        else
          ''
        end
      end

      def short_title(celebration)
        if celebration.cycle == :sanctorale
          # naive attempt to strip feast titles
          celebration.title.sub /,[^,]*$/, ''
        else
          celebration.title
        end
      end

      def additional_celebrations(day)
        size = day.celebrations.size

        size > 1 ? " +#{size-1}" : ''
      end

      def vespers(day)
        day.vespers_from_following? ? '>' : ''
      end
    end
  end
end
