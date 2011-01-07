require 'lib/perb'
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
        opts.banner = "Usage: perb [options]"
        opts.separator ""

        opts.on_tail("-h", "--help", "Show this message.") do
           puts opts
           exit
        end

        opts.on("-t", "--test-yml TEST_YML", "Path to yaml file with test definitions.") do |value|
          options[:test_yml]=value
        end
      end
      p_options.parse!

      options

      rescue OptionParser::InvalidOption 
      puts p_options 
      exit 0 
    end

    def run
      results = Perb::PerbTest.new(@options[:test_yml]).run
      Perb::PerbBase.create!(results)
    end
  end
end
