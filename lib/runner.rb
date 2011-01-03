require 'lib/perb/perb_parser'
require 'lib/perb/perb_test'
require 'lib/perb/perb_base'
require 'lib/runner'
require 'optparse'

module Perb
  class Runner
    class << self
      def run(argv)
        self.new(argv).run
      end
    end

    def initialize(argv)
      @options=parse_options
      #@test_yml = argv[0]
    end

    def parse_options
      options={}
      p_options = OptionParser.new do |opts|
        opts.on("-h", "--help", "Show this message.") do
           puts opts
           exit
        end

        opts.on("-t", "--test-yml TEST_YML", "Path to yaml file with test definitions.") do |value|
          options[:test_yml]=value
        end
      end
      p_options.parse!
      options
    end

    def run
      results = Perb::PerbTest.new(@options[:test_yml]).run
      Perb::PerbBase.create!(results)
    end
  end
end
