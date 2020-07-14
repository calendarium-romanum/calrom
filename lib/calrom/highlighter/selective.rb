module Calrom
  module Highlighter
    class Selective
      def initialize(selected, highlighter)
        @selected = selected
        @highlighter = highlighter
      end

      def colour(text, colour)
        if @selected.include? __method__
          @highlighter.public_send __method__, text, colour
        else
          text
        end
      end

      def rank(text, rank)
        if @selected.include? __method__
          @highlighter.public_send __method__, text, rank
        else
          text
        end
      end

      def today(text)
        if @selected.include? __method__
          @highlighter.public_send __method__, text
        else
          text
        end
      end
    end
  end
end
