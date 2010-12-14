require 'perb/perb_parser'
require 'perb/perb_test'
require 'perb/perb_base'
require 'perb/perb'

module Perb
  class Runner
    def run
      results = Perb::PerbTest.new().run
      Perb::PerbBase.create!(results)
    end
  end
end
