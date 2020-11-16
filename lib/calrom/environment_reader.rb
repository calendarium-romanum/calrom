module Calrom
  # Reads configuration from environment variables
  class EnvironmentReader
    def self.call(config = nil)
      new(config || Config.new).call
    end

    def initialize(config)
      @config = config
    end

    def call
      today

      @config
    end

    private

    def today
      with_envvar 'CALROM_CURRENT_DATE' do |value, name|
        begin
          @config.today = Date.parse value
        rescue ArgumentError
          raise InputError.new "value of environment variable #{name} is not a valid date"
        end
      end
    end

    def with_envvar(name)
      value = ENV[name]

      yield value, name if value
    end
  end
end
