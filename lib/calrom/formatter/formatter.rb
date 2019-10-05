module Calrom
  module Formatter
    class Formatter
      def initialize(highlighter)
        @highlighter = highlighter
      end

      attr_reader :highlighter

      def call(days)
      end
    end
  end
end
