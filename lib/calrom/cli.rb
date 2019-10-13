module Calrom
  class CLI
    def self.call(argv)
      config = OptionParser.call argv
      calendar = config.calendar

      config.formatter.call calendar, config.date_range
    end
  end
end
