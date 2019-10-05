module Calrom
  class DateRange < Range
  end

  class Year < DateRange
    def initialize(year)
      super Date.new(year, 1, 1), Date.new(year, 12, 31)
    end

    def to_s
      first.year.to_s
    end
  end

  class Month < DateRange
    def initialize(year, month)
      super Date.new(year, month, 1), Date.new(year, month + 1, 1) - 1
    end

    def to_s
      "#{first.month}/#{first.year}"
    end
  end

  class Day < DateRange
    def initialize(date)
      super date, date
    end

    def to_s
      first.to_s
    end
  end
end