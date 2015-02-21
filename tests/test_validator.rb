require 'test/unit'
require_relative '../lib/validator'

class TestValidator < Test::Unit::TestCase
  def setup
  end

  # vimrc_contentsキーが存在し、Hashである場合trueを返す
  def test_valid_with_valid_vimrc_contents
    @validator = VimFactory::Validator.new({'vimrc_contents' => {}})
    result = @validator.valid?

    assert_equal result, true
  end

  # vimrc_contetnsがnilの場合、valid?はfalseを返す
  def test_valid_with_vimrc_contents_is_nil
    @validator = VimFactory::Validator.new({'vimrc_contents' => nil})
    result = @validator.valid?

    assert_equal result, false
    assert_equal @validator.error, 'Required parameter `vimrc_contents` is missing'
  end

  # vimrc_contetnsがHash以外の型の場合、valid?はfalseを返す
  def test_valid_with_vimrc_contents_is_not_Hash
    @validator = VimFactory::Validator.new({'vimrc_contents' => 'foo'})
    result = @validator.valid?

    assert_equal result, false
    assert_equal @validator.error, 'Type of `vimrc_contents` must be Hash'
  end
end
