require 'test/unit/testcase'
require 'test/unit'
require 'pathname'
require 'rubygems'
require 'ruby-debug'

require File.expand_path('../../lib/perb', __FILE__)

class Test::Unit::TestCase
  def setup
    @parser=Perb::PerbParser.new(["Total: connections 500 requests 839 replies 678 test-duration 9.368 s",
                                  "Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (1 samples)"])
  end
end
