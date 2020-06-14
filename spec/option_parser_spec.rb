require 'spec_helper'

describe Calrom::OptionParser do
  describe 'general' do
    it 'receives Array of command line arguments, builds Config' do
      expect(described_class.([])).to be_a Calrom::Config
    end
  end

  describe 'date range' do
    let(:today) { Date.today }
    let(:current_month) { Calrom::Month.new(today.year, today.month) }
    let(:current_year) { Calrom::Year.new(today.year) }

    it 'current month is default' do
      range = described_class.([]).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq current_month
    end

    it 'current year' do
      range = described_class.(%w(-y)).date_range
      expect(range).to be_a Calrom::Year
      expect(range).to eq current_year
    end

    it 'specified year' do
      range = described_class.(%w(2000)).date_range
      expect(range).to be_a Calrom::Year
      expect(range).to eq Calrom::Year.new(2000)
    end

    it 'specified month' do
      range = described_class.(%w(-m6)).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq Calrom::Month.new(today.year, 6)
    end

    it 'specified month of the previous year' do
      range = described_class.(%w(-m6p)).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq Calrom::Month.new(today.year - 1, 6)
    end

    it 'specified month of the following year' do
      range = described_class.(%w(-m6f)).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq Calrom::Month.new(today.year + 1, 6)
    end

    it 'specified year and month (argument)' do
      range = described_class.(%w(5 2000)).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq Calrom::Month.new(2000, 5)
    end

    it 'specified year and month (option)' do
      range = described_class.(%w(-m 5 2000)).date_range
      expect(range).to be_a Calrom::Month
      expect(range).to eq Calrom::Month.new(2000, 5)
    end

    describe 'debugging options' do
      it '"current" month (specified by a debugging option -d)' do
        range = described_class.(%w(-d 2000-01)).date_range
        expect(range).to be_a Calrom::Month
        expect(range).to eq Calrom::Month.new(2000, 1)
      end

      it 'highlighting option -H has no effect on date range' do
        range = described_class.(%w(-H 2000-01-01)).date_range
        expect(range).to be_a Calrom::Month
        expect(range).to eq current_month
      end
    end
  end
end
