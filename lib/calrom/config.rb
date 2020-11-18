module Calrom
  class Config
    DEFAULT_DATA = CR::Data::GENERAL_ROMAN_ENGLISH
    DEFAULT_LOCALE = :en

    def initialize
      self.today = Date.today
      self.date_range = Month.new(today.year, today.month)
      self.sanctorale = []
      self.configs = []
      self.verbose = false
      self.highlight = Set.new(%i(colour rank today))
      self.transfer_to_sunday = []
      self.temporale_extensions = []
    end

    attr_accessor :today,
                  :date_range,
                  :formatter,
                  :colours,
                  :sanctorale,
                  :transfer_to_sunday,
                  :temporale_extensions,
                  :locale,
                  :configs,
                  :load_parents,
                  :highlight,
                  :verbose

    def calendar
      if is_remote_calendar?
        if @sanctorale.size > 1
          raise InputError.new '--calendar option provided multiple times, but at least one of the calendars is remote. Remote calendars cannot be layered.'
        end

        return CR::Remote::Calendar.new date_range.first.year, @sanctorale.last
      end

      CR::PerpetualCalendar.new(sanctorale: build_sanctorale, temporale_options: temporale_options)
    end

    def build_sanctorale
      if @sanctorale.empty?
        return DEFAULT_DATA.load
      end

      data = @sanctorale.collect do |s|
        expanded = File.expand_path s

        if s == '-'
          CR::SanctoraleLoader.new.load_from_string STDIN.read
        else
          data_file =
            if File.file? expanded
              SanctoraleFile.new expanded
            elsif CR::Data[s]
              CR::Data[s]
            else
              raise InputError.new "\"#{s}\" is neither a file, nor a valid identifier of a bundled calendar. " +
                                   "Valid identifiers are: " +
                                   CR::Data.each.collect(&:siglum).inspect
            end

          if load_parents?
            begin
              data_file.load_with_parents
            rescue NoMethodError
              # As of calendarium-romanum 0.7.0 `SanctoraleFactory.load_with_parents` crashes
              # when any of the calendars lacks the YAML front matter.
              # Until that is fixed, let's fallback to the simple load.
              data_file.load
            end
          else
            data_file.load
          end
        end
      end

      CR::SanctoraleFactory.create_layered(*data)
    end

    def temporale_options
      {transfer_to_sunday: transfer_to_sunday, extensions: temporale_extensions}
    end

    def locale
      @locale || locale_in_file_metadata || DEFAULT_LOCALE
    end

    def formatter
      if @formatter == :list || (@formatter.nil? && date_range.is_a?(Day))
        Formatter::List.new highlighter(Highlighter::List), today
      elsif @formatter == :short
        Formatter::Condensed.new highlighter(Highlighter::List), today
      elsif @formatter == :easter
        Formatter::Easter.new
      elsif @formatter == :calendars
        Formatter::Calendars.new highlighter(Highlighter::Overview), today
      elsif @formatter == :csv
        Formatter::Csv.new
      elsif @formatter == :json
        Formatter::Json.new
      else
        Formatter::Overview.new highlighter(Highlighter::Overview), today
      end
    end

    def highlighter(colourful)
      if (self.colours == false || (self.colours.nil? && !STDOUT.isatty))
        return Highlighter::No.new
      end

      Highlighter::Selective.new highlight, colourful.new
    end

    # Should calendars be loaded including parent files they reference?
    def load_parents?
      load_parents == true ||
        (load_parents.nil? && @sanctorale.size == 1)
    end

    def highlight
      if date_range.is_a? Day
        @highlight - [:today]
      else
        @highlight
      end
    end

    private

    def locale_in_file_metadata
      is_remote_calendar? ? nil : build_sanctorale.metadata['locale']&.to_sym
    end

    def is_remote_calendar?
      !!@sanctorale.find {|s| s =~ /^https?:\/\// }
    end
  end
end
