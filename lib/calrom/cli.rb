module Calrom
  class CLI
    def self.call(argv)
      begin
        config = OptionParser.call argv
        calendar = config.calendar
      rescue ::OptionParser::InvalidOption, InputError => e
        STDERR.puts e.message
        exit 1
      end

      I18n.locale = config.locale

      config.formatter.call calendar, config.date_range
    end
  end
end
