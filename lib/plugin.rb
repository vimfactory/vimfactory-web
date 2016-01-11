module VimFactory
  class Plugin
    def initialize(id)
      @default_pluginpath = "/home/vimfactory/vimstorage/default/plugin"
      @pluginpath = "/home/vimfactory/vimstorage/#{id}/runtimepath/plugin"
    end
    
    def enable(plugin_name)
      all_disable
      FileUtils.copy("#{@default_pluginpath}/#{plugin_name}", @pluginpath)
    end

    def all_disable
      Dir::glob("#{@pluginpath}/*.vim").each do |pluginfile|
        puts pluginfile
        File.unlink(pluginfile) if File.exist?(pluginfile)
      end
    end
  end
end
