module VimFactory
  class Plugin
    DEFAULT_PLUGINPATH = "/home/vimfactory/vimstorage/default/plugin"
    def initialize(id)
      @pluginpath = "/home/vimfactory/vimstorage/#{id}/runtimepath/plugin"
    end

    def enable(plugin_name)
      disable
      FileUtils.copy("#{DEFAULT_PLUGINPATH}/#{plugin_name}", @pluginpath)
      nil # vimrcへの記載はなし
    end

    def disable
      Dir::glob("#{@pluginpath}/*.vim").each do |pluginfile|
        File.unlink(pluginfile) if File.exist?(pluginfile)
      end
      nil # vimrcへの記載はなし
    end
  end
end
