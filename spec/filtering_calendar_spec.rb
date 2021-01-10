require_relative 'spec_helper'

describe Calrom::FilteringCalendar do
  let(:inner_calendar) { double(CR::Calendar) }
  let(:calendar) { described_class.new(inner_calendar, days_filter_expressions, celebrations_filter_expressions) }
  let(:days_filter_expressions) { [] }
  let(:celebrations_filter_expressions) { [] }

  let(:date) { Date.new }

  describe 'TRIDUUM constant name clash workaround' do
    describe 'the problem' do
      it do
        # we include all CalendariumRomanum "value constants" as top-level constants
        # in the filtering context to spare the users typing, but due to a name clash
        # CR::Seasons::TRIDUUM is unaccessible this way
        expect(CR::Constants::TRIDUUM).to be CR::Ranks::TRIDUUM

        # and, of course, comparing a Rank with a Season (accidentally sharing the same name)
        # results in unequality
        expect { CR::Ranks::TRIDUUM == CR::Seasons::TRIDUUM }
          .to raise_exception NoMethodError # not a particularly elegant behaviour, should be fixed
        expect(CR::Seasons::TRIDUUM == CR::Ranks::TRIDUUM).to be false
      end
    end

    describe 'filtering days by season' do
      [
        'season == TRIDUUM',
        'TRIDUUM == season',
      ].each do |expression|
        describe expression do
          let(:days_filter_expressions) { [expression] }

          it 'finds a matching entry' do
            day = CR::Day.new season: CR::Seasons::TRIDUUM, celebrations: [CR::Celebration.new]
            allow(inner_calendar).to receive(:[]).and_return(day)

            result = calendar[date]
            expect(result).not_to be_skipped
            expect(result.celebrations).to eq day.celebrations
          end

          it 'drops a non-matching entry' do
            day = CR::Day.new season: CR::Seasons::LENT, celebrations: [CR::Celebration.new]
            allow(inner_calendar).to receive(:[]).and_return(day)

            result = calendar[date]
            expect(result).to be_skipped
          end
        end
      end
    end

    describe 'filtering celebrations by rank' do
      [
        'rank == TRIDUUM',
        'TRIDUUM == rank',
      ].each do |expression|
        describe expression do
          let(:celebrations_filter_expressions) { [expression] }

          it 'finds a matching entry' do
            day = CR::Day.new celebrations: [CR::Celebration.new(rank: CR::Ranks::TRIDUUM)]
            allow(inner_calendar).to receive(:[]).and_return(day)

            result = calendar[date]
            expect(result).not_to be_skipped
            expect(result.celebrations).to eq day.celebrations
          end

          it 'drops a non-matching entry' do
            day = CR::Day.new celebrations: [CR::Celebration.new]
            allow(inner_calendar).to receive(:[]).and_return(day)

            result = calendar[date]
            expect(result).to be_skipped
          end
        end
      end
    end
  end
end
