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
end
