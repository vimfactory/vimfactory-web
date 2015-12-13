require "test/unit"
require_relative "../lib/vimrc_preview"

class TestVimrcPreview < Test::Unit::TestCase
  @@present_vimrc = "tests/test_vimrc"
  @@not_present_vimrc = "tests/test_novimrc"
  def setup
    test_vimrc = <<-EOS
" testvimrc
set number
set autoindent
    EOS
    File.open 'tests/test_vimrc', 'w' do |f|
      f.write test_vimrc
    end
  end
  
  def teardown
    File.unlink(@@present_vimrc) if File.exist?(@@present_vimrc)
  end
  
  # vimrcファイルを適切に読み込めること 
  def test_read_present_vimrc
    vimrc_preview = VimFactory::VimrcPreview.new(@@present_vimrc)
    assert_equal(vimrc_preview.get.include?("\" testvimrc"), true)
    assert_equal(vimrc_preview.get.include?("set number"), true)
    assert_equal(vimrc_preview.get.include?("set autoindent"), true)
  end

  # vimrcファイルがない場合にはnilを返すこと
  def test_read_not_present_vimrc
    vimrc_preview = VimFactory::VimrcPreview.new(@@not_present_vimrc)
    assert_equal(vimrc_preview.get, nil)
  end
end
