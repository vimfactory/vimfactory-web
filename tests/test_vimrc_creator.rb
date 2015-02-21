require 'test/unit'
require_relative '../lib/vimrc_creator'

class TestVimrcCreator < Test::Unit::TestCase
  @@filepath = './test_vimrc'

  def teardown
    if File.exist?(@@filepath)
      File.unlink(@@filepath)
    end
  end

  # toggle_optionの書き込み処理
  # 値がtrue
  def test_create_with_toggle_option_true
    @contents = { 'ruler' => true }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set ruler\n")
    end
  end

  # toggle_optionの書き込み処理
  # 値がfalse
  def test_create_with_toggle_option_false
    @contents = { 'ruler' => false }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set noruler\n")
    end
  end

  # toggle_optionの書き込み処理
  # 値がtrue/false以外
  def test_create_with_invalid_toggle_option
    @contents = { 'ruler' => 'foo' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # string_optionの書き込み処理
  # キーが妥当、値が妥当
  def test_create_with_valid_string_option
    @contents = { 'encoding' => 'sjis' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set encoding=sjis\n")
    end
  end

  # string_optionの書き込み処理
  # キーが妥当、値が不正
  def test_create_with_invalid_string_option
    @contents = { 'encoding' => 'foo' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # string_optionの書き込み処理
  # キーが不正、値が妥当
  def test_create_with_invalid_string_option2
    @contents = { 'encoding___' => 'sjis' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # string_optionの書き込み処理
  # キーが不正、値が不正
  def test_create_with_invalid_string_option3
    @contents = { 'encoding___' => 'foo' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # number_optionの書き込み処理
  # キーが妥当、値が妥当
  def test_create_with_valid_number_option
    @contents = { 'tabstop' => 10 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set tabstop=10\n")
    end
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最小値
  def test_create_with_min_number_option4
    @contents = { 'tabstop' => 0 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set tabstop=0\n")
    end
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最大値
  def test_create_with_max_number_option
    @contents = { 'tabstop' => 100 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "set tabstop=100\n")
    end
  end

  # number_optionの書き込み処理
  # キーが不正、値が妥当
  def test_create_with_invalid_number_option
    @contents = { 'tabstop___' => 100 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最小値以下
  def test_create_with_invalid_number_option2
    @contents = { 'tabstop' => -1 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最大値以上
  def test_create_with_invalid_number_option3
    @contents = { 'tabstop' => 101 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # colorschemeの書き込み処理
  # 妥当な値
  def test_create_with_valid_colorscheme
    @contents = { 'colorscheme' => 'desert' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, "colorscheme desert\n")
    end
  end

  # colorschemeの書き込み処理
  # 不正な値
  def test_create_with_invalid_colorscheme
    @contents = { 'colorscheme' => 'foo' }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      line = file.gets
      assert_equal(line, nil)
    end
  end

  # 全オプションの書き込み処理
  def test_create_with_all_option
    @contents = {
      'ruler' => true,
      'syntax' => 'on',
      'tabstop' => 4,
      'colorscheme' => 'morning'
    }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create()

    File.open(@@filepath) do |file|
      assert_equal(file.gets, "set ruler\n")
      assert_equal(file.gets, "set syntax=on\n")
      assert_equal(file.gets, "set tabstop=4\n")
      assert_equal(file.gets, "colorscheme morning\n")
    end
  end
end
