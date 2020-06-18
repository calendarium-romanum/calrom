require 'shellwords'

module Calrom
  class CLI
    def self.call(argv)
      begin
        config = OptionParser.call(rc_options + argv)
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
    def self.rc_options
      ['/etc/calromrc', '~/.calromrc']
        .collect {|f| File.expand_path f }
        .select {|f| File.file? f }
        .collect {|f| Shellwords.split(File.read(f)) }
        .flatten
    end
  end
end
