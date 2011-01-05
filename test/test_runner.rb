require File.expand_path('../helper.rb', __FILE__)
require File.expand_path('../../lib/runner.rb', __FILE__)

class TestRunner < Test::Unit::TestCase
  include Perb
  def test_truth
    assert true
  end

  def test_existence_of_modules_and_classes
    assert defined? Perb
    assert defined? Runner
  end

  def test_existence_of_methods
    assert_respond_to klass, :run
  end

  def test_class_method_run
    assert_kind_of String, Perb::PerbBase.connection.instance_variable_get(:@config)[:database]
    assert_equal "/home/chris/.perb/perb.sqlite3", Perb::PerbBase.connection.instance_variable_get(:@config)[:database]

    ary = Perb::PerbTest.new(config).run
    records = Perb::PerbBase.all.size
    klass.run(config)
    assert_equal records+1, Perb::PerbBase.all.size
  end

  protected
    def klass
      Perb::Runner
    end

    def config
      File.expand_path('../fixtures/tests/test1.yml', __FILE__)
    end
end
