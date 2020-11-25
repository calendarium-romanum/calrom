module Calrom
  module Formatter
    # Prints list of available bundled calendars
    class Calendars < Formatter
      def call(calendar, date_range)
        last_locale = nil
        CR::Data.each do |d|
          sanctorale = d.load_with_parents
          meta = sanctorale.metadata
          puts if last_locale && last_locale != meta['locale']
          default = d == Config::DEFAULT_DATA ? ' [default]' : ''
          puts "%-20s:  %s  [%s]%s" % [d.siglum, meta['title'], meta['locale'], default]

          next unless meta['components']

          parents =
            meta['components']
              .collect {|c| c['extends'] }
              .compact
              .map {|e| e.is_a?(Array) ? e : [e] } # 'extends' is String or Array
              .flatten
              .map {|p| p.sub(/\.\w{3,4}$/, '') } # file name to "siglum"
          parents.each {|p| puts "  <  #{p}" }
          last_locale = meta['locale']
        end
      end
    end
  end
end
