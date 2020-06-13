module Calrom
  class CLI
    def self.call(argv)
      begin
        config = OptionParser.call argv
      rescue InputError => e
        STDERR.puts e.message
        exit 1
      end

      calendar = config.calendar

      config.formatter.call calendar, config.date_range
    end
  end
end
