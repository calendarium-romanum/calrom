module Calrom
  module Highlighter
    class Overview < List
      def rank(text, rank)
        if rank.solemnity?
          ColorizedString.new(text).colorize(mode: :bold)
        elsif rank.feast?
          ColorizedString.new(text).colorize(mode: :underline)
        else
          text
        end
      end
    end
  end
end
