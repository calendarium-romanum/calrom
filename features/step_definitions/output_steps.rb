Then(/^the output should contain (\d+) to (\d+) day entries$/) do |from, to|
  # select only lines which are first line of a day entry
  day_entries =
    last_command_started.stdout
      .lines
      .select {|l| l =~ /^\w+\s+\d{1,2}/}

  expect(day_entries.size).to be_between(from.to_i, to.to_i)
end

Then('the output should mention some feasts of saints') do
  expect(last_command_started.stdout).to include 'Saint'
end

Then('the stderr should not contain traceback') do
  output = last_command_started.stderr

  expect(output).not_to match /^\s+from .+?:\d+:in `.+?'/
end

Then(/^the output should contain (some|no) colour codes$/) do |value|
  colours_reset = "\u001b[0m"

  if value == 'some'
    expect(last_command_started.stdout).to include colours_reset
  elsif value == 'no'
    expect(last_command_started.stdout).not_to include colours_reset
  else
    raise 'unexpected'
  end
end
