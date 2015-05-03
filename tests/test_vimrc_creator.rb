require "test/unit"
require_relative "../lib/vimrc_creator"

class TestVimrcCreator < Test::Unit::TestCase
  @@filepath = "./test_vimrc"
  @@filepath_fixed = "./test_fixed_vimrc"

  def teardown
    File.unlink(@@filepath) if File.exist?(@@filepath)
    File.unlink(@@filepath_fixed) if File.exist?(@@filepath_fixed)
  end

  # 固定設定の配列を返すメソッド
  # -> 不正な値を登録しようとした際に
  #    固定設定のみ反映されているかを確認する際に使う
  def fixed_options
    @vimrc_creator = VimFactory::VimrcCreator.new({}, @@filepath_fixed)
    @vimrc_creator.create
    File.read(@@filepath_fixed).split("\n")
  end

  # 設定値として何も渡さない場合、固定設定のみが書き込まれる
  def test_create_with_option_none
    @vimrc_creator = VimFactory::VimrcCreator.new({}, @@filepath)
    @vimrc_creator.create
    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # toggle_optionの書き込み処理
  # 値がtrue
  def test_create_with_toggle_option_true
    @contents = { "ruler" => true }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set ruler"), true)
  end

  # toggle_optionの書き込み処理
  # 値がfalse
  def test_create_with_toggle_option_false
    @contents = { "ruler" => false }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set ruler"), false)
  end

  # toggle_optionの書き込み処理
  # 値がtrue/false以外
  def test_create_with_invalid_toggle_option
    @contents = { "ruler" => "foo" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set ruler"), false)
  end

  # string_optionの書き込み処理
  # キーが妥当、値が妥当
  def test_create_with_valid_string_option
    @contents = { "syntax" => "on" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set syntax=on"), true)
  end

  # string_optionの書き込み処理
  # キーが妥当、値が不正 => 固定設定のみ
  def test_create_with_invalid_string_option
    @contents = { "syntax" => "foo" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # string_optionの書き込み処理
  # キーが不正、値が妥当
  def test_create_with_invalid_string_option2
    @contents = { "syntax__" => "on" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # string_optionの書き込み処理
  # キーが不正、値が不正
  def test_create_with_invalid_string_option3
    @contents = { "syntax__" => "foo" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # number_optionの書き込み処理
  # キーが妥当、値が妥当
  def test_create_with_valid_number_option
    @contents = { "tabstop" => 10 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set tabstop=10"), true)
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最小値
  def test_create_with_min_number_option4
    @contents = { "tabstop" => 0 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set tabstop=0"), true)
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最大値
  def test_create_with_max_number_option
    @contents = { "tabstop" => 100 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set tabstop=100"), true)
  end

  # number_optionの書き込み処理
  # キーが不正、値が妥当
  def test_create_with_invalid_number_option
    @contents = { "tabstop___" => 100 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最小値以下
  def test_create_with_invalid_number_option2
    @contents = { "tabstop" => -1 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # number_optionの書き込み処理
  # キーが妥当、値が最大値以上
  def test_create_with_invalid_number_option3
    @contents = { "tabstop" => 101 }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # colorschemeの書き込み処理
  # 妥当な値
  def test_create_with_valid_colorscheme
    @contents = { "colorscheme" => "desert" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("colorscheme desert"), true)
  end

  # colorschemeの書き込み処理
  # 不正な値
  def test_create_with_invalid_colorscheme
    @contents = { "colorscheme" => "foo" }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file, fixed_options)
  end

  # 全オプションの書き込み処理
  def test_create_with_all_option
    @contents = {
      "ruler" => true,
      "syntax" => "on",
      "tabstop" => 4,
      "colorscheme" => "morning"
    }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set ruler"), true)
    assert_equal(file.include?("set syntax=on"), true)
    assert_equal(file.include?("set tabstop=4"), true)
    assert_equal(file.include?("colorscheme morning"), true)
  end

  # 全オプションの書き込み処理2
  def test_create_with_all_option2
    @contents = {
      "ruler" => true,
      "number" => "foo", # 不正
      "syntax" => "on",
      "encoding" => "utf-9", # 不正
      "tabstop" => 4,
      "shiftwidth" => 1000, # 不正
      "colorscheme" => "vimfactory" # 不正
    }
    @vimrc_creator = VimFactory::VimrcCreator.new(@contents, @@filepath)
    @vimrc_creator.create

    file = File.read(@@filepath).split("\n")
    assert_equal(file.include?("set ruler"), true)
    assert_equal(file.include?("set number"), false)
    assert_equal(file.include?("set syntax=on"), true)
    assert_equal(file.include?("set encoding=utf-9"), false)
    assert_equal(file.include?("set tabstop=4"), true)
    assert_equal(file.include?("set shiftwidth=1000"), false)
    assert_equal(file.include?("colorscheme vimfactory"), false)
  end
end
