require 'spec_helper'

describe 'date ranges' do
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
end
