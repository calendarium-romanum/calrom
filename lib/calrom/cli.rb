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
      rescue ::OptionParser::InvalidOption, InputError => e
        STDERR.puts e.message
        exit 1
      end

      I18n.locale = config.locale

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
        RcParser.call content
      end.flatten
    end
  end
end
