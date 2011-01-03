require File.expand_path('../helper.rb', __FILE__)
    #assert klass.new

class TestPerbTest < Test::Unit::TestCase
  include Perb
  def test_truth
    assert true
  end

  def test_existence_of_perb_test
    assert defined? PerbTest
  end

  def test_existence_of_methods
    assert_respond_to klass.new(nil), :run
    assert_respond_to klass.new(nil), :command
  end

  def test_run_returns_an_array_of_hashes
    ary = klass.new(nil).run
    assert_kind_of Array, ary
    ary.each do |a|
      assert_kind_of Hash, a
    end
  end

  protected
    def klass
      PerbTest
    end
end
