module Calrom
  class Config
    def initialize
      self.today = Date.today
      self.date_range = CR::Util::Month.new(today.year, today.month)
    end

    attr_accessor :today, :date_range, :formatter

    def calendar
      CR::PerpetualCalendar.new(sanctorale: CR::Data::GENERAL_ROMAN_ENGLISH.load)
    end

    def formatter
      if @formatter == :list
        Formatter::List.new Highlighter::List.new, today
      else
        Formatter::Overview.new Highlighter::Overview.new, today
      end
    end
  end
end
