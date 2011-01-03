require File.expand_path('../helper.rb', __FILE__)

class TestRunner < Test::Unit::TestCase
  include Perb
  def test_truth
    assert true
  end

  def test_existence_of_modules_and_classes
    assert defined? Perb
    assert defined? Perb::Runner
  end

  def test_existence_of_methods
    assert_respond_to klass, :run
  end

  def test_class_method_run
    #assert_kind_of String, klass.run(nil)
  end

  protected
    def klass
      Perb::Runner
    end
end
