require 'date'

When(/^current year is (\d+) and month (\d+)$/) do |year, month|
  month_beginning = Date.new year.to_i, month.to_i
  date = (month_beginning ... month_beginning.next_month).to_a.sample # random date of the month

  append_environment_variable 'CALROM_CURRENT_DATE', date.to_s
end
