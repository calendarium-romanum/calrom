module Calrom
  module Formatter
    class Formatter
      def initialize(highlighter, today, io = STDOUT)
        @highlighter = highlighter
        @today = today
        @io = io
      end

      attr_reader :highlighter, :today

      def call(calendar, date_range)
      end

      private

      def puts(s = '')
        @io.puts s
      end

      def print(s)
        @io.print s
      end
    end
  end
end
