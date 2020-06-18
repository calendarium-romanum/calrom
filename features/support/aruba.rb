require 'aruba/cucumber'

Aruba.configure do |config|
  # run all scenarios with a custom home directory, different from my actual home
  config.home_directory = File.join(config.root_directory, config.working_directory)
end
