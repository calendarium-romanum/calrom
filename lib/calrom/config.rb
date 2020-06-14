module Calrom
  class Config
    def initialize
      self.today = Date.today
      self.date_range = Month.new(today.year, today.month)
    end

    attr_accessor :today, :date_range, :formatter, :colours

    def calendar
      CR::PerpetualCalendar.new(sanctorale: CR::Data::GENERAL_ROMAN_ENGLISH.load)
    end

    def formatter
      if @formatter == :list || (@formatter.nil? && date_range.is_a?(Day))
        Formatter::List.new highlighter(Highlighter::List), today
      elsif @formatter == :easter
        Formatter::Easter.new
      else
        Formatter::Overview.new highlighter(Highlighter::Overview), today
      end
    end

    def highlighter(colourful)
      if self.colours == false
        return Highlighter::No.new
      end

      colourful.new
    end
  end
end
