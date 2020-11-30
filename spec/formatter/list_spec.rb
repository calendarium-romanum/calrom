require_relative '../spec_helper'

describe Calrom::Formatter::List do
  let(:calendar) { Calrom::FilteringCalendar.new CR::PerpetualCalendar.new }
  let(:highlighter) { Calrom::Highlighter::No.new }
  let(:today) { Date.today }

  describe 'header' do
    [
      Calrom::Month.new(2000, 1),
      Calrom::Year.new(2000),
      Calrom::Day.new(Date.new(2000, 1, 1)),
      Calrom::ThreeMonths.new(2000, 1),
      Calrom::DateRange.new(Date.new(2000, 1, 1), Date.new(2000, 2, 3))
    ].each do |range|
      describe range.class.name do
        it 'looks as expected' do
          io = StringIO.new

          described_class.new(highlighter, today, io).(calendar, range)

          first, second, third = io.string.lines

          expect(first.strip).not_to be_empty # (date range)
          expect(second.strip).to be_empty # empty line
          expect(third.strip).not_to be_empty # first line of the first entry or first month heading
        end
      end
    end
  end
end
