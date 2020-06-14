require 'spec_helper'

describe Calrom::Formatter::Overview do
  describe 'formatting a single whole month' do
    let(:calendar) { CalendariumRomanum::PerpetualCalendar.new }
    let(:highlighter) { Calrom::Highlighter::Overview.new }
    let(:range) { Calrom::Month.new 2020, 6 }

    before do
      # TODO: don't touch global configuration, use "null highlighter" instead
      ColorizedString.disable_colorization = true
    end

    it 'produces expected layout' do
      io = StringIO.new

      described_class.new(highlighter, Date.today).(calendar, range, io)

      expected = [
        "      June 2020       ",
        "Su Mo Tu We Th Fr Sa  ",
        "    1  2  3  4  5  6  ",
        " 7  8  9 10 11 12 13  ",
        "14 15 16 17 18 19 20  ",
        "21 22 23 24 25 26 27  ",
        "28 29 30              ",
        "                      ",
        "",
      ].join "\n"

      expect(io.string).to eq expected
    end
  end
end
