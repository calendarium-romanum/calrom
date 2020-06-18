require 'shellwords'

module Calrom
  # Parses configuration file contents to an ARGV-like Array
  class RcParser
    def self.call(content)
      Shellwords.split(content.gsub(/#.+?$/, ''))
    end
  end
end
