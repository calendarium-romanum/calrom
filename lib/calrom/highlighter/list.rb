module Calrom
  module Highlighter
    class List
      COLOUR_OVERRIDE = {
        # 'colorize' does not know colour :violet
        CR::Colours::VIOLET => :magenta,
      }

      def colour(text, colour)
        ColorizedString.new(text).colorize(COLOUR_OVERRIDE[colour] || colour.symbol)
      end

      def rank(text, rank)
        if rank.solemnity?
          ColorizedString
            .new(rank >= CR::Ranks::FEAST_PROPER ? text.upcase : text)
            .colorize(mode: :bold)
        else
          text
        end
      end

      def today(text)
        ColorizedString.new(text).colorize(background: :light_black)
      end
    end
  end
end
