require File.expand_path('../helper.rb', __FILE__)

class TestPerbParse < Test::Unit::TestCase
  include Perb

  def test_existence_of_perb_test
    assert defined? PerbParser
  end

  def test_existence_of_methods
    assert_respond_to klass, :new
    assert_respond_to klass.new([]), :find_needle
    assert_respond_to klass.new([]), :find_needles
    assert_respond_to klass.new([]), :haystacks_and_needles
    assert_respond_to klass.new([]), :parse
    assert_respond_to klass.new([]), :get_matching_output_line
  end

  def test_initializer_takes_an_array
    assert_raise(ArgumentError){klass.new}
    assert_raise(ArgumentError){klass.new("not an array")}
    assert_nothing_raised(){ klass.new([])}
  end

  def test_find_needle_returns_string
    assert_kind_of String, @parser.find_needle("needle", "haystack")
  end

  def test_get_matching_output_line_returns_a_string
    current_haystack_line = /Total: connections (\d*)/
    assert_kind_of String, @parser.get_matching_output_line(current_haystack_line)
  end

  def test_get_matching_output_line_returns_the_correct_line_from_result
    current_output_line = "Total: connections 500 requests 839 replies 678 test-duration 9.368 s"
    #"Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (1 samples)"
    current_haystack_line = /Total: connections (\d*)/

    assert_equal current_output_line, @parser.get_matching_output_line(current_haystack_line)
  end

  def test_find_needle_finds_needle_in_haystack
    haystack = "Total: connections 500 requests 839 replies 678 test-duration 9.368 s"
    needle = /Total: connections (\d*)/
    assert_equal "500", @parser.find_needle(needle, haystack)
  end

  def test_find_needles_returns_a_hash
    assert_kind_of Hash, @parser.find_needles({}, "haystack")
    assert_raises(ArgumentError){@parser.find_needles("not a hash", "haystack")}
  end

  def test_find_needles_returns_a_hash_of_attributes_and_needles
    haystack = "Total: connections 500 requests 839 replies 678 test-duration 9.368 s"
    needles = {:actual_conns       => /Total: connections (\d*)/,
               :total_requests     => /Total: connections .*requests (\d*)/,
               :total_replies      => /Total: connections .*replies (\d*)/,
               :test_duration      => /Total: connections .*test-duration (\d*\.\d*)/}
    assert_equal "500", @parser.find_needles(needles, haystack)[:actual_conns]
    assert_equal "839", @parser.find_needles(needles, haystack)[:total_requests]
    assert_equal "678", @parser.find_needles(needles, haystack)[:total_replies]
    assert_equal "9.368", @parser.find_needles(needles, haystack)[:test_duration]
  end

  def test_parse_returns_a_hash
    assert_kind_of Hash, @parser.parse
  end

  def test_haystacks_and_needles_matches_expected_input
    input =["httperf --timeout=5 --client=0/1 --server=localhost --port=3000 --uri=/ --rate=5 --send-buffer=4096 --recv-buffer=16384 --num-conns=30 --num-calls=10",
            "Maximum connect burst length: 1",
            "Total: connections 30 requests 0 replies 0 test-duration 5.800 s",
            "Connection rate: 5.2 conn/s (193.3 ms/conn, <=1 concurrent connections)",
            "Connection time [ms]: min 0.0 avg 0.0 max 0.0 median 0.0 stddev 0.0",
            "Connection time [ms]: connect 0.0",
            "Connection length [replies/conn]: 0.000",
            "Request rate: 0.0 req/s (0.0 ms/req)",
            "Request size [B]: 0.0",
            "Reply rate [replies/s]: min 0.0 avg 0.0 max 0.0 stddev 0.0 (1 samples)",
            "Reply time [ms]: response 0.0 transfer 0.0",
            "Reply size [B]: header 0.0 content 0.0 footer 0.0 (total 0.0)",
            "Reply status: 1xx=0 2xx=0 3xx=0 4xx=0 5xx=0",
            "CPU time [s]: user 4.09 system 1.70 (user 70.5% system 29.2% total 99.7%)",
            "Net I/O: 0.0 KB/s (0.0*10^6 bps)",
            "Errors: total 30 client-timo 0 socket-timo 0 connrefused 30 connreset 0",
            "Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0"]
    #h_and_n=@parser.haystacks_and_needles.keys.reverse
    @parser.haystacks_and_needles.each_key do |k|
      results = 0
      input.each do |i|
        if(!(i=~k).nil? && (i =~ k) <= 0)
          results+=1
        end
      end
      assert_equal 1, results
    end
  end

  protected
    def klass
      PerbParser
    end
end
