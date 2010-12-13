require 'yaml'
require 'rubygems'
require "active_record"
require "ruby-debug"

module Perb
  class PerbTest
    include Perb

    attr_reader :settings

    def initialize(settings_yml=File.expand_path('../../../config/settings.yml', __FILE__))
      self.settings=(settings_yml)
      #settings.values.each do |test_settings|
      #  # set the parameters
      #  command = "httperf"
      #  test_settings.each_pair do  |key, val|
      #    command += " --#{key}=#{val}"
      #  end

      #  # run the command
      #  run
      #  #save_result_to_database(match)
      #end
    end

    def settings=(settings_yml)
      @settings=(YAML::load_file(settings_yml))
    end

    def run
      settings.values.each do |test_settings|
        result = `#{command(test_settings)}`
        result_by_line = result.split("\n").delete_if{|e| e.empty?}
        #@lines_and_expressions = {}
      end
    end

    def command(test_settings)
      command = "httperf"
      test_settings.each_pair do  |key, val|
        command += " --#{key}=#{val}"
      end
    end
  end
end 
