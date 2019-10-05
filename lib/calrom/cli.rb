module Calrom
  class CLI
    def self.call(argv)
      config = OptionParser.call argv
      calendar = config.calendar

      puts

      enumerator = Enumerator.new do |yielder|
        config.date_range.each do |date|
          yielder.yield calendar[date]
        end
      end

      config.formatter.call enumerator
    end
  end
end
