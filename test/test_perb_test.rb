require File.expand_path('../helper.rb', __FILE__)

class TestPerbTest < Test::Unit::TestCase
  include Perb
  def test_truth
    assert true
  end

  def test_existence_of_perb_test
    assert defined? PerbTest
  end

  def test_existence_of_methods
    assert klass.new
    assert_respond_to klass.new, :run
    assert_respond_to klass.new, :command
  end

  protected
    def klass
      PerbTest
    end
end
