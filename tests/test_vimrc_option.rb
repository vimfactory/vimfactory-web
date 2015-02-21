require 'test/unit'
require_relative '../lib/vimrc_option'

class TestVimrcOption < Test::Unit::TestCase
  # toggle_option?は引数がTOGGLE_OPTIONS定数（Array）の
  # 要素であればtrueを返し、そうでない場合にfalseを返す
  def test_toggle_option?
    assert_equal true,  VimFactory::VimrcOption.toggle_option?('ruler')
    assert_equal false, VimFactory::VimrcOption.toggle_option?('encoding')
    assert_equal false, VimFactory::VimrcOption.toggle_option?('matchtime')
    assert_equal false, VimFactory::VimrcOption.toggle_option?('colorscheme')
    assert_equal false, VimFactory::VimrcOption.toggle_option?('desert')
    assert_equal false, VimFactory::VimrcOption.toggle_option?(nil)
    assert_equal false, VimFactory::VimrcOption.toggle_option?(false)
    assert_equal false, VimFactory::VimrcOption.toggle_option?('')
  end

  # number_option?は引数がNUMBER_OPTIONS定数（Hash）の
  # キーであればtrueを返し、そうでない場合にfalseを返す
  def test_number_option?
    assert_equal true,  VimFactory::VimrcOption.number_option?('matchtime')
    assert_equal false, VimFactory::VimrcOption.number_option?('ruler')
    assert_equal false, VimFactory::VimrcOption.number_option?('encoding')
    assert_equal false, VimFactory::VimrcOption.number_option?('colorscheme')
    assert_equal false, VimFactory::VimrcOption.number_option?('desert')
    assert_equal false, VimFactory::VimrcOption.number_option?(nil)
    assert_equal false, VimFactory::VimrcOption.number_option?(false)
    assert_equal false, VimFactory::VimrcOption.number_option?('')
  end

  # string_option?は引数がSTRING_OPTIONS定数（Hash）の
  # キーであればtrueを返し、そうでない場合にfalseを返す
  def test_string_option?
    assert_equal true,  VimFactory::VimrcOption.string_option?('encoding')
    assert_equal false, VimFactory::VimrcOption.string_option?('matchtime')
    assert_equal false, VimFactory::VimrcOption.string_option?('ruler')
    assert_equal false, VimFactory::VimrcOption.string_option?('colorscheme')
    assert_equal false, VimFactory::VimrcOption.string_option?('desert')
    assert_equal false, VimFactory::VimrcOption.string_option?(nil)
    assert_equal false, VimFactory::VimrcOption.string_option?(false)
    assert_equal false, VimFactory::VimrcOption.string_option?('')
  end
end
