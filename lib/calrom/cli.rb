module Calrom
  class CLI
    def self.call(argv)
      config = OptionParser.call argv
      calendar = config.calendar

      enumerator = Enumerator.new do |yielder|
        config.date_range.each do |date|
          yielder.yield calendar[date]
        end
      end

      config.formatter.call enumerator, config.date_range
    end
  end
end
