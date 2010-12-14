require File.expand_path('../helper.rb', __FILE__)

class TestPerbBase < Test::Unit::TestCase
  include Perb

  def test_existence_of_perb_base
    assert defined? PerbBase
  end

  def test_existence_of_methods
    assert_respond_to klass, :new
  end

  def test_initializer_takes_string
    assert_nothing_raised(){ klass.new()}
  end

  protected
    def klass
      PerbBase
    end
end
