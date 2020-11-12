require 'spec_helper'

describe 'date ranges' do
  describe Calrom::DateRange do
    describe '#each_month' do
      it 'one month' do
        d = Date.new 2000, 1, 1
        expect(described_class.new(d, d+30).each_month.to_a)
          .to eq [Calrom::Month.new(2000, 1)]
      end

      it 'two months' do
        range = described_class.new(Date.new(2000, 1, 1), Date.new(2000, 2, 29))
        expect(range.each_month.to_a)
          .to eq [Calrom::Month.new(2000, 1), Calrom::Month.new(2000, 2)]
      end

      it 'two months at the end of a year' do
        range = described_class.new(Date.new(2000, 12, 1), Date.new(2001, 1, 31))
        expect(range.each_month.to_a)
          .to eq [Calrom::Month.new(2000, 12), Calrom::Month.new(2001, 1)]
      end

      it 'two months at the end of a year' do
        range = described_class.new(Date.new(2000, 1, 1), Date.new(2002, 2, 5))
        expect(range.each_month.to_a.size).to be 26
      end

      it 'incomplete first month' do
        range = described_class.new(Date.new(2000, 1, 30), Date.new(2000, 2, 29))
        expect(range.each_month.to_a)
          .to eq([
                   Calrom::DateRange.new(Date.new(2000, 1, 30), Date.new(2000, 1, 31)),
                   Calrom::Month.new(2000, 2)
                 ])
      end

      it 'incomplete last month' do
        range = described_class.new(Date.new(2000, 1, 1), Date.new(2000, 2, 5))
        expect(range.each_month.to_a)
          .to eq([
                   Calrom::Month.new(2000, 1),
                   Calrom::DateRange.new(Date.new(2000, 2, 1), Date.new(2000, 2, 5))
                 ])
      end

      it 'incomplete single month' do
        d = Date.new 2000, 1, 5
        range = described_class.new(d, d+1)
        expect(range.each_month.to_a)
          .to eq [range]
      end
    end
  end

  describe Calrom::Month do
    1.upto(12) do |i|
      it "supports month #{i}" do
        described_class.new(2000, i)
      end

      it "yields Dates of the given year and month #{i}" do
        described_class.new(2000, i).each do |date|
          expect(date.year).to be 2000
          expect(date.month).to be i
        end
      end
    end
  end

  describe Calrom::Year do
    describe '#each_month' do
      it 'yields months of the year' do
        year = described_class.new(2002)
        expect {|b| year.each_month(&b) }
          .to yield_successive_args(
                Calrom::Month.new(2002, 1),
                Calrom::Month.new(2002, 2),
                Calrom::Month.new(2002, 3),
                Calrom::Month.new(2002, 4),
                Calrom::Month.new(2002, 5),
                Calrom::Month.new(2002, 6),
                Calrom::Month.new(2002, 7),
                Calrom::Month.new(2002, 8),
                Calrom::Month.new(2002, 9),
                Calrom::Month.new(2002, 10),
                Calrom::Month.new(2002, 11),
                Calrom::Month.new(2002, 12),
              )
      end
    end
  end

  describe Calrom::ThreeMonths do
    it 'display the previous, current and next month surrounding today' do
      subject = described_class.new(2002, 03)
      expect(subject.first).to eq(Date.new(2002, 2))
      expect(subject.last).to eq(Date.new(2002, 4, -1))
    end

    it 'when current mouth is January, print December (last year), \
        January and February (current year)' do
      subject = described_class.new(2002, 01)
      expect(subject.first).to eq(Date.new(2001, 12))
      expect(subject.last).to eq(Date.new(2002, 2, -1))
    end

    it 'when current mouth is December, print November, \
        December (current year) and January (next year)' do
      subject = described_class.new(2002, 12)
      expect(subject.first).to eq(Date.new(2002, 11))
      expect(subject.last).to eq(Date.new(2003, 1, -1))
    end
  end
end
