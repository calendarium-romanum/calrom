require 'delegate'

module Calrom
  # decorates /(Perpetual)?Calendar/, returns data filtered
  class FilteringCalendar < SimpleDelegator
    def initialize(calendar, days_filter_expressions=[], celebrations_filter_expressions=[])
      super(calendar)

      @days_filter = proc do |day|
        days_filter_expressions.all? do |expr|
          day.instance_eval expr
        rescue StandardError => e
          raise filter_error e, expr
        end
      end

      @celebrations_filter = proc do |celebration|
        celebrations_filter_expressions.all? do |expr|
          celebration.instance_eval expr
        rescue StandardError => e
          raise filter_error e, expr
        end
      end
    end

    def [](arg)
      raw = super(arg)

      unless @days_filter.(raw)
        return FilteredDay.build_skipped raw
      end

      FilteredDay.new raw, raw.celebrations.select(&@celebrations_filter)
    end

    def each_day_in_range(range, include_skipped: false)
      return to_enum(__method__, range, include_skipped: include_skipped) unless block_given?

      range.each do |date|
        day = self[date]
        yield day if (include_skipped || !day.skipped?)
      end
    end

    private

    def filter_error(exception, expression)
      InputError.new "Filter expression '#{expression}' raised #{exception.class}: #{exception.message}"
    end

    class FilteredDay < SimpleDelegator
      def initialize(day, filtered_celebrations)
        super(day)

        @filtered_celebrations = filtered_celebrations
      end

      def self.build_skipped(day)
        new day, []
      end

      def celebrations
        @filtered_celebrations
      end

      def skipped?
        celebrations.empty?
      end
    end
  end
end
