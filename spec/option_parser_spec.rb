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

    it 'specified date' do
      range = described_class.(%w(2000-01-02)).date_range
      expect(range).to be_a Calrom::Day
      expect(range.first).to eq(Date.new(2000, 1, 2))
    end

    it 'specified date in distant future' do
      range = described_class.(%w(100000-01-02)).date_range
      expect(range).to be_a Calrom::Day
      expect(range.first).to eq(Date.new(100000, 1, 2))
    end

    it 'specified previous, current and next month surrounding today' do
      year = Date.today.year
      month = Date.today.month
      range = described_class.(%w(-3)).date_range

      expect(range).to be_a Calrom::ThreeMonths
      expect(range).to eq(Calrom::ThreeMonths.new(today.year, today.month))
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
      expect(sanctorale).to eq CR::Data::GENERAL_ROMAN_ENGLISH.load
    end

    it 'single calendar' do
      sanctorale = described_class.(%w(--calendar=universal-la)).build_sanctorale
      expect(sanctorale).to eq CR::Data::GENERAL_ROMAN_LATIN.load
    end

    it 'layer multiple calendars' do
      sanctorale = described_class.(%w(--calendar=czech-cs --calendar=czech-cechy-cs)).build_sanctorale
      expect(sanctorale)
        .to eq CR::SanctoraleFactory.create_layered(
                 CR::Data['czech-cs'].load,
                 CR::Data['czech-cechy-cs'].load
               )
    end
  end

  describe 'equivalency of result based on input' do
    def self.stringify(argv)
      argv.join ' '
    end

    describe 'non-equivalent options' do
      [
        [%w(--today), %w()],
        [%w(-m1), %w(-m2)],
      ].each do |a,b|
        it "'#{stringify a}' does not equal '#{stringify b}'" do
          expect(described_class.(a))
            .not_to eq described_class.(b)
        end
      end
    end

    describe 'equivalent options' do
      [
        # literally the same input
        [%w(), %w()],
        [%w(1990), %w(1990)],
        [%w(-m1), %w(-m1)],

        # empty vs. explicitly requested default settings
        [%w(), %w(--locale=en)],

        # short vs. long options
        [%w(-m1), %w(--month=1)],
        [%w(-y), %w(--year)],

        # long options: equal sign vs. space
        [%w(--config=a), %w(--config a)],

        # long options: full vs. shortenned (shortest unambiguous)
        [%w(--config=a), %w(--con=a)],
        [%w(--month=1), %w(--m=1)],
        [%w(--year), %w(--yea)],
        [%w(--yesterday), %w(--yes)],
        [%w(--today), %w(--tod)],
        [%w(--tomorrow), %w(--tom)],
        [%w(--calendar=universal-en), %w(--ca=universal-en)],
        [%w(--load-parents), %w(--loa)],
        [%w(--no-load-parents), %w(--no-l)],
        [%w(--to-sunday=epiphany), %w(--to-=epiphany)],
        [%w(--temporale-extension=ChristEternalPriest), %w(--te=ChristEternalPriest)],
        [%w(--locale=en), %w(--loc=en)],
        [%w(--list), %w(--li)],
        [%w(--format=overview), %w(--f=overview)],
        [%w(--day-filter=true), %w(--d=true)],
        [%w(--celebration-filter=true), %w(--ce=true)],
        [%w(--easter), %w(--e)],
        [%w(--calendars), %w(--calendars)], # no shortening possible due to --calendar=
        [%w(--color), %w(--col)],
        [%w(--no-color), %w(--no-c)],
        [%w(--verbose), %w(--verb)],
        [%w(--current-month=2000-01), %w(--cu=2000-01)],
        [%w(--highlight-date=2000-01-01), %w(--hi=2000-01-01)],

        # TODO: --version and --help cannot be tested, as they result in `exit` call in OptionParser,
        #   preventing execution of subsequent examples
        #
        # [%w(--version), %w(--vers)],
        # [%w(--help), %w(--h)],

        # pre-defined option values: full vs. shortenned
        [%w(--to-sunday=epiphany), %w(--to-sunday=e)],
        [%w(--to-sunday=ascension), %w(--to-sunday=a)],

        [%w(--temporale-extension=ChristEternalPriest), %w(--temporale-extension=C)],

        [%w(--format=overview), %w(--format=o)],
      ].each do |a,b|
        it "'#{stringify a}' equals '#{stringify b}'" do
          expect(described_class.(a))
            .to eq described_class.(b)
        end
      end
    end
  end
end
