require 'yaml'
require "perb/perb_parser"

module Perb
  class PerbTest
    attr_reader :settings

    def initialize(settings_yml=File.expand_path('~/.perb/settings.yml'))
      self.settings=(settings_yml)
    end

    def settings=(settings_yml)
      @settings=(YAML::load_file(settings_yml))
    end

    def run
      results=[]
      settings.values.each do |test_settings|
        result = `#{command(test_settings)}`
        result_by_line = result.split("\n").delete_if{|e| e.empty?}
        results << PerbParser.new(result_by_line).parse
      end
      results
    end

    def command(test_settings)
      command = "httperf"

      test_settings.each_pair do  |key, val|
        command += " --#{key} #{val}"
      end

      command
    end
  end
end
