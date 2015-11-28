module VimFactory
  #
  # == vimrcのプレビューを機能を提供するクラス
  #
  class VimrcPreview
    def initialize(filepath)
      @filepath = filepath.to_s
    end

    def get
      return nil unless File.exist?(@filepath)
      File.open(@filepath, 'r').read
    end
  end
end
