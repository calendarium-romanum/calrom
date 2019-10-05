module Calrom
  module Formatter
    class Formatter
      def initialize(highlighter, today)
        @highlighter = highlighter
        @today = today
      end

      attr_reader :highlighter, :today

      def call(days)
      end
    end
  end
end
