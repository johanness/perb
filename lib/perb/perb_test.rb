require 'yaml'
require 'perb/perb_parser'
require 'perb/session'

module Perb
  class PerbTest
    def initialize(settings_path)
      if(settings_path==nil)
        settings_path=File.expand_path('~/.perb/settings.yml')
      end
      @session=Perb::Session.new(settings_path)
      #self.settings=(settings_path)
    end
    
    def run
      results=[]
      @session.each do |test|
        result = `#{command(test.last)}`
        result_by_line = result.split("\n").delete_if{|e| e.empty?}
        parsed_result = PerbParser.new(result_by_line).parse
        parsed_result[:title]=test.first
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
