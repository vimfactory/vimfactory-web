require "test/unit"
require_relative "../lib/plugin"

class TestPlugin < Test::Unit::TestCase
  def setup
    @container_id = 'test1234'
    @pluginpath = "/home/vimfactory/vimstorage/#{@container_id}/runtimepath/plugin"
    FileUtils.mkdir_p(@pluginpath)
  end

  def teardown
    FileUtils.rm_rf("/home/vimfactory/vimstorage/#{@container_id}")
  end

  # プラグインファイルを指定したIDのディレクトリコピーができること
  def test_plugin_enable
    VimFactory::Plugin.enable(@container_id, "endwise.vim")
    assert_equal(File.exists?("#{@pluginpath}/endwise.vim"), true)
  end
  
  # 存在しないプラグインファイルを有効にした場合、なにもしないこと
  def test_wrong_plugin_enable
    VimFactory::Plugin.enable(@container_id, "wrong.vim")
    assert_equal(File.exists?("#{@pluginpath}/wrong.vim"), false)
  end

  # 指定したIDのディレクトリ内の.vimファイルが削除されること 
  def test_plugin_disable
    VimFactory::Plugin.enable(@container_id, "endwise.vim")
    VimFactory::Plugin.disable(@container_id)
    assert_equal(File.exists?("#{@pluginpath}/endwise.vim"), false)
  end

  # 指定したIDのディレクトリ内の.vimファイルが以外は削除されないこと
  def test_plugin_disable_with_not_vimfile
    FileUtils.touch("#{@pluginpath}/notvimfile")
    VimFactory::Plugin.enable(@container_id, "endwise.vim")
    VimFactory::Plugin.disable(@container_id)
    assert_equal(File.exists?("#{@pluginpath}/endwise.vim"), false)
    assert_equal(File.exists?("#{@pluginpath}/notvimfile"), true)
  end
end
