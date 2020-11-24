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
      self.filter_days = []
    end

    ATTRIBUTES = [
      :today,
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
      :verbose,
      :filter_days,
    ]

    attr_accessor *ATTRIBUTES

    def ==(b)
      self.class == b.class &&
        ATTRIBUTES.all? {|prop| public_send(prop) == b.public_send(prop) }
    end

    def calendar
      if is_remote_calendar?
        if @sanctorale.size > 1
          raise InputError.new '--calendar option provided multiple times, but at least one of the calendars is remote. Remote calendars cannot be layered.'
        end

        return CR::Remote::Calendar.new date_range.first.year, @sanctorale.last
      end

      FilteringCalendar.new(
        CR::PerpetualCalendar.new(sanctorale: build_sanctorale, temporale_options: temporale_options),
        filter_days
      )
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

    def build_formatter
      highlighter = Highlighter::List
      klass = @formatter && Formatter.const_get(@formatter.capitalize)

      if @formatter.nil?
        klass = date_range.is_a?(Day) ? Formatter::List : Formatter::Overview
      end

      if [Formatter::Calendars, Formatter::Overview].include? klass
        highlighter = Highlighter::Overview
      end

      klass.new build_highlighter(highlighter), today
    end

    def build_highlighter(colourful)
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
