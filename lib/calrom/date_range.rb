module Calrom
  class DateRange < Range
    def each_month
      return to_enum(:each_month) unless block_given?

      if first.year == last.year && first.month == last.month
        # a single month or it's part
        yield self
        return
      end

      (Month.new(first.year, first.month) .. Month.new(last.year, last.month))
        .each_with_index do |m,i|
        if i == 0 && first.day > 1
          # first month, incomplete
          end_of_month = first.next_month - first.day + 1
          yield self.class.new(first, m.last)
        elsif m.first.year == last.year && m.first.month == last.month && last != m.last
          # last month, incomplete
          yield self.class.new(m.first, last)
        else
          yield m
        end
      end
    end
  end

  class Year < DateRange
    def initialize(year)
      super Date.new(year, 1, 1), Date.new(year, 12, 31)
    end

    def to_s
      first.year.to_s
    end

    def each_month
      return to_enum(:each_month) unless block_given?

      1.upto(12) {|month| yield Month.new(first.year, month) }
    end
  end

  class Month < DateRange
    def initialize(year, month)
      @year = year
      @month = month
      super Date.new(year, month, 1), next_month_beginning - 1
    end

    def to_s
      first.strftime '%B %Y'
    end

    def each_month
      return to_enum(:each_month) unless block_given?

      yield self
    end

    def succ
      n = next_month_beginning
      self.class.new(n.year, n.month)
    end

    def <=>(other)
      years_cmp = year <=> other.year

      if years_cmp != 0
        years_cmp
      else
        month <=> other.month
      end
    end

    protected

    attr_reader :year, :month

    private

    def next_month_beginning
      if @month == 12
        Date.new(@year + 1, 1, 1)
      else
        Date.new(@year, @month + 1, 1)
      end
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
