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

    def each_month
      1.upto(12) {|month| yield Month.new(first.year, month) }
    end
  end

  class Month < DateRange
    def initialize(year, month)
      next_month_beginning =
        if month == 12
          Date.new(year + 1, 1, 1)
        else
          Date.new(year, month + 1, 1)
        end
      super Date.new(year, month, 1), next_month_beginning - 1
    end

    def to_s
      "#{first.month}/#{first.year}"
    end

    def each_month
      yield self
    end
  end

  class Day < DateRange
    def initialize(date)
      super date, date
    end

    def to_s
      first.to_s
    end

    def each_month
      yield self
    end
  end
end
