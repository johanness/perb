require 'perb/perb_parser'
require 'perb/perb_test'
require 'perb/perb_base'
require 'perb/perb'

module Perb
  class Runner
    def initialize(argv)
      run(argv[0])
    end

    def run(test_yml)
      results = Perb::PerbTest.new(test_yml).run
      Perb::PerbBase.create!(results)
    end
  end
end
