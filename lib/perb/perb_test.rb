require 'yaml'
require "perb/perb_parser"

module Perb
  class PerbTest
    attr_reader :settings

    def initialize(settings_yml)
      if(settings_yml==nil)
        settings_yml=File.expand_path('~/.perb/settings.yml')
      end
      self.settings=(settings_yml)
    end

    def settings=(settings_yml)
      @settings=(YAML::load_file(settings_yml))
    end

    def run
      results=[]
      settings.each_pair do |test_name, test_settings|
        result = `#{command(test_settings)}`
        result_by_line = result.split("\n").delete_if{|e| e.empty?}
        parsed_result = PerbParser.new(result_by_line).parse
        parsed_result[:title]=test_name
        results << parsed_result
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
