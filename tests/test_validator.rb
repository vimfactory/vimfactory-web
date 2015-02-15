require 'test/unit'
require '../lib/validator'

class TestValidator < Test::Unit::TestCase
  def setup
    @validator = VimFactory::Validator.new
  end

  # idがnilの場合、valid?はfalseを返す
  def test_valid_without_id
    @validator.vimrc_contents = {}
    result = @validator.valid?

    assert_equal result, false
    assert_equal @validator.error, 'Required parameter `id` is missing'
  end

  # vimrc_contetnsがnilの場合、valid?はfalseを返す
  def test_valid_without_vimrc_contents
    @validator.id = 1
    result = @validator.valid?

    assert_equal result, false
    assert_equal @validator.error, 'Required parameter `vimrc_contents` is missing'
  end

  # idもvimrc_contentsも存在する場合、valid?はtrueを返す
  def test_valid_with_id_and_vimrc_contents
    @validator.id = 1
    @validator.vimrc_contents = {}
    result = @validator.valid?

    assert_equal result, true
  end
end
