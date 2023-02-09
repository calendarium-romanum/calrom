require_relative '../spec_helper'

describe Calrom::Formatter::Condensed do
  let(:calendar) { Calrom::FilteringCalendar.new CR::PerpetualCalendar.new(sanctorale: CR::Data::GENERAL_ROMAN_ENGLISH.load, vespers: true) }
  let(:highlighter) { Calrom::Highlighter::No.new }
  let(:today) { Date.today }

  [
    ['ferial', Date.new(2021, 1, 11), "Monday, 1st week in Ordinary Time G\n"],
    ['with optional memorials', Date.new(2021, 1, 13), "Wednesday, 1st week in Ordinary Time G +1\n"],
    ['Sunday', Date.new(2021, 1, 17), "+2nd Sunday in Ordinary Time G\n"],
    ['feast', Date.new(2021, 1, 10), "+The Baptism of the Lord W\n"],
    ['solemnity', Date.new(2021, 1, 6), "*The Epiphany W\n"],
    ['Vespers from the following', Date.new(2021, 1, 5), "Tuesday after Christmas Octave W>\n"],
  ].each do |label, date, expected|
    it label do
      range = Calrom::Day.new date
      io = StringIO.new

      described_class.new(highlighter, today, io).(calendar, range)

      expect(io.string).to eq expected
    end
  end
end
