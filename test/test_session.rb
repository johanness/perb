require File.expand_path('../helper.rb', __FILE__)
    #assert klass.new

class TestSession < Test::Unit::TestCase
  def test_truth
    assert true
  end

  def test_existence_of_session
    assert defined? Perb::Session
  end

  def test_existence_of_methods
    #assert_respond_to klass, :initialize
    #assert_respond_to klass.new(config), :command
  end

  def test_new_takes_one_argument
    assert_raise(ArgumentError){klass.new}
  end

  def test_session_can_accept_yml_files
    assert_raise(Errno::ENOENT){klass.new(File.expand_path('../fixtures/does_not_exist.yml', __FILE__))}
    assert_nothing_raised(){ klass.new(File.expand_path('../fixtures/tests/test1.yml', __FILE__))}
  end

  def test_session_can_accept_directories
    assert_nothing_raised(){ klass.new(File.expand_path('../fixtures/tests/', __FILE__))}
  end

  def test_each_returns_a_two_element_array
    session=klass.new(File.expand_path('../fixtures/tests', __FILE__))
    titles=['my perb test', 'test2 in yaml2', 'test1 in yaml2']
    session.each do |t|
      assert_kind_of Array, t
      assert_equal 2, t.size
      assert titles.include?(t.first)
      assert_kind_of Hash, t.last
    end
  end

  protected
    def klass
      Perb::Session
    end
end
