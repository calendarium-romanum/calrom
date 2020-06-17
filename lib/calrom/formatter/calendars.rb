require 'yaml'

module Calrom
  module Formatter
    # Prints list of available bundled calendars
    class Calendars < Formatter
      def call(calendar, date_range)
        last_locale = nil
        CR::Data.each do |d|
          meta = load_front_matter d
          puts if last_locale && last_locale != meta['locale']
          puts "%-20s:  %s  [%s]" % [d.siglum, meta['title'], meta['locale']]
          last_locale = meta['locale']
        end
      end

      def load_front_matter(data_file)
        YAML.load File.read data_file.path
      end
    end
  end
end
