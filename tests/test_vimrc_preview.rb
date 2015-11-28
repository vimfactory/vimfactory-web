require "test/unit"
require_relative "../lib/vimrc_preview"

class TestVimrcPreview < Test::Unit::TestCase
  @@present_vimrc = "tests/test_vimrc"
  @@not_present_vimrc = "tests/test_novimrc"
  class << self
    def startup
      test_vimrc = <<-EOS
" testvimrc
set number
set autoindent
      EOS
      File.open 'tests/test_vimrc', 'w' do |f|
        f.write test_vimrc
      end
    end
  
    def shutdown
      File.unlink(@@present_vimrc) if File.exist?(@@present_vimrc)
    end
  end
  
  # vimrcファイルを適切に読み込めること 
  def test_read_present_vimrc
    vimrc_preview = VimFactory::VimrcPreview.new(@@present_vimrc)
    assert_equal(vimrc_preview.get.include?("testvimrc"), true)
  end

  # 存在しないvimrcファイルを読んだ時に例外をはくこと
  def test_read_not_present_vimrc
    vimrc_preview = VimFactory::VimrcPreview.new(@@not_present_vimrc)
    assert_raise("Errno::ENOENT") do
      vimrc_preview.get
    end
  end
end
