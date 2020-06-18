module Calrom
  class Config
    DEFAULT_DATA = CR::Data::GENERAL_ROMAN_ENGLISH
    DEFAULT_LOCALE = :en

    def initialize
      self.today = Date.today
      self.date_range = Month.new(today.year, today.month)
      self.sanctorale = []
    end

    attr_accessor :today, :date_range, :formatter, :colours, :sanctorale, :locale

    def calendar
      CR::PerpetualCalendar.new(sanctorale: build_sanctorale)
    end

    def build_sanctorale
      if @sanctorale.empty?
        return DEFAULT_DATA.load
      end

      data = @sanctorale.collect do |s|
        if File.file? s
          CR::SanctoraleLoader.new.load_from_file s
        elsif CR::Data[s]
          CR::Data[s].load
        else
          raise InputError.new "\"#{s}\" is neither a file, nor a valid identifier of a bundled calendar. " +
                               "Valid identifiers are: " +
                               CR::Data.each.collect(&:siglum).inspect
        end
      end

      CR::SanctoraleFactory.create_layered(*data)
    end

    def locale
      @locale || locale_in_file_name || DEFAULT_LOCALE
    end

    def formatter
      if @formatter == :list || (@formatter.nil? && date_range.is_a?(Day))
        Formatter::List.new highlighter(Highlighter::List), today
      elsif @formatter == :easter
        Formatter::Easter.new
      elsif @formatter == :calendars
        Formatter::Calendars.new highlighter(Highlighter::Overview), today
      else
        Formatter::Overview.new highlighter(Highlighter::Overview), today
      end
    end

    def highlighter(colourful)
      if (self.colours == false || (self.colours.nil? && !STDOUT.isatty))
        return Highlighter::No.new
      end

      colourful.new
    end

    private

    def locale_in_file_name
      locale = (sanctorale.last || DEFAULT_DATA.siglum).split('-').last.to_sym

      I18n.available_locales.include?(locale) ? locale : nil
    end
  end
end
