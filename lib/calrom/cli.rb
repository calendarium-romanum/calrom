module Calrom
  class CLI
    def self.call(argv)
      begin
        config_files = OptionParser.call(argv).configs

        config = OptionParser.call(
          rc_options(config_files.empty? ? nil : config_files) +
          argv
        )

        calendar = config.calendar
      rescue ::OptionParser::ParseError, InputError => e
        STDERR.puts e.message
        exit 1
      end

      begin
        I18n.locale = config.locale
      rescue I18n::InvalidLocale
        locales_help = I18n.available_locales.join(', ')
        STDERR.puts "Locale '#{config.locale}' unsupported (available locales: #{locales_help})"
        exit 1
      end

      config.formatter.call calendar, config.date_range
    end

    private

    # options loaded from configuration files
    def self.rc_options(paths = nil)
      return [] if paths == ['']

      paths ||=
        ['/etc/calromrc', '~/.calromrc']
          .collect {|f| File.expand_path f }
          .select {|f| File.file? f }

      paths.collect do |f|
        begin
          content = File.read(f)
        rescue Errno::ENOENT
          raise InputError.new("Configuration file \"#{f}\" not found")
        end

        options = RcParser.call content

        begin
          OptionParser.call(options)
        rescue ::OptionParser::ParseError => e
          raise InputError.new("Error loading '#{f}': #{e.message}")
        end

        options
      end.flatten
    end
  end
end
