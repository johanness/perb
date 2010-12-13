require File.expand_path('../helper.rb', __FILE__)

class TestPerb < Test::Unit::TestCase
  include Perb
  def test_truth
    assert true
  end

  def test_existence_of_module
    assert defined? Perb
  end

  #def test_existence_of_methods
  #  assert respond_to?(:measure)
  #end
end
