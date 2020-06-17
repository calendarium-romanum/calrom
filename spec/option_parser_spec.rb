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

    it 'yesterday' do
      range = described_class.(%w(--yesterday)).date_range
      expect(range).to be_a Calrom::Day
      expect(range.first).to eq(Date.today - 1)
    end

    it 'today' do
      range = described_class.(%w(--today)).date_range
      expect(range).to be_a Calrom::Day
      expect(range.first).to eq Date.today
    end

    it 'tomorrow' do
      range = described_class.(%w(--tomorrow)).date_range
      expect(range).to be_a Calrom::Day
      expect(range.first).to eq(Date.today + 1)
    end

    describe 'conflicting range type options' do
      it 'later wins - year' do
        range = described_class.(%w(-m 1 -y)).date_range
        expect(range).to be_a Calrom::Year
      end

      it 'later wins - month' do
        range = described_class.(%w(-y -m 1)).date_range
        expect(range).to be_a Calrom::Month
      end

      it 'option wins over argument - date over year' do
        range = described_class.(%w(--today 1900)).date_range
        expect(range).to be_a Calrom::Day
        expect(range.first).to eq Date.today
      end

      # TODO usually option wins over argument (like in cal) and I'm not sure if this
      # exception is tolerable. Maybe a new option like -m and -y should be added to force day
      # and date argument should not win over the last date range option.
      it 'date argument wins over month option' do
        range = described_class.(%w(-m 1 2000-01-01)).date_range
        expect(range).to be_a Calrom::Day
      end
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

  describe 'sanctorale' do
    it 'default' do
      sanctorale = described_class.([]).build_sanctorale
      expect(sanctorale).to eq CalendariumRomanum::Data::GENERAL_ROMAN_ENGLISH.load
    end

    it 'single calendar' do
      sanctorale = described_class.(%w(--calendar=universal-la)).build_sanctorale
      expect(sanctorale).to eq CalendariumRomanum::Data::GENERAL_ROMAN_LATIN.load
    end

    it 'layer multiple calendars' do
      sanctorale = described_class.(%w(--calendar=czech-cs --calendar=czech-cechy-cs)).build_sanctorale
      expect(sanctorale)
        .to eq CalendariumRomanum::SanctoraleFactory.create_layered(
                 CalendariumRomanum::Data['czech-cs'].load,
                 CalendariumRomanum::Data['czech-cechy-cs'].load
               )
    end
  end
end
