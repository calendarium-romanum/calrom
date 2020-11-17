module Calrom
  module Formatter
    class Condensed < Formatter
      def call(calendar, date_range)
        date_range.each do |date|
          day calendar[date]
        end
      end

      private

      def day(liturgical_day)
        c = liturgical_day.celebrations.first

        colour = highlighter.colour(c.colour.name[0].upcase, c.colour)
        rank = highlighter.rank(rank(c.rank), c.rank)
        title = short_title c

        puts "#{colour}#{rank} #{title}"
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
    end
  end
end
