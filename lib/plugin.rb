module VimFactory
  # vimのプラグインを有効無効にするクラス
  class Plugin
    DEFAULT_PLUGINPATH = '/home/vimfactory/vimstorage/default/plugin'
    def self.enable(container_id, plugin_name)
      disable(container_id)
      pluginpath = "#{DEFAULT_PLUGINPATH}/#{plugin_name}"
      FileUtils.copy(pluginpath, create_pluginpath(container_id)) if File.exist?(pluginpath)
      nil # vimrcへの記載はなし
    end

    def self.disable(container_id)
      Dir.glob("#{create_pluginpath(container_id)}/*.vim").each do |pluginfile|
        File.unlink(pluginfile) if File.exist?(pluginfile)
      end
      nil # vimrcへの記載はなし
    end

    def self.create_pluginpath(container_id)
      "/home/vimfactory/vimstorage/#{container_id}/runtimepath/plugin"
    end
  end
end
