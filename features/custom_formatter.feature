Feature: Custom formatter
  In order to allow advanced customization of output
  I want the command to allow defining custom formatters

Scenario: Use custom executable with a custom formatter added to calrom
  Given a file named "calrom_with_custom_formatter.rb" with:
  """
  # In order to load custom Ruby code, we create our own
  # calrom executable

  require 'calrom'

  module Calrom
    module Formatter
      # class added to the Calrom::Formatter module
      # is automatically used by calrom as another formatter
      class Custom < Formatter
        def call(calendar, date_range)
          puts 'Expected output'
        end
      end
    end
  end

  Calrom::CLI.call ARGV
  """
  When I run `ruby calrom_with_custom_formatter.rb --format=custom`
  Then the output should contain "Expected output"
