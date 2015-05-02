require_relative './vimrc_option'

module VimFactory
  #
  # == 与えられた設定値に従いvimrcを作成するクラス
  #
  class VimrcCreator
    # コンストラクタ
    # @param [Hash] vimrc_contents vimrcの設定値
    # @param [String] filepath 作成するvimrcのパス
    def initialize(vimrc_contents = {}, filepath)
      @vimrc_contents = vimrc_contents
      @filepath = filepath.to_s
    end

    # vimrc作成処理
    # @return [void]
    def create
      File.open(@filepath, 'w') do |file|
        @vimrc_contents.merge(VimrcOption::FIXED_OPTIONS).each do |option, value|
          line = build_option_line(option, value)
          file.puts(line) if line.nil? == false
        end
      end
    end

    private

    # 設定行を組み立てる
    # @param [String] option オプション名
    # @param [String] value オプション値
    # @return [String, nil] 設定行
    def build_option_line(option, value)
      case
      when VimrcOption.toggle_option?(option)
        return "set #{option}"   if value == true
        return "set no#{option}" if value == false
      when VimrcOption.string_option?(option)
        if VimrcOption::STRING_OPTIONS[option].include?(value)
          return "set #{option}=#{value}"
        end
      when VimrcOption.number_option?(option)
        if VimrcOption::NUMBER_OPTIONS[option].include?(value)
          return "set #{option}=#{value}"
        end
      when option == 'colorscheme'
        if VimrcOption::COLOR_SCHEMES.include?(value)
          return "colorscheme #{value}"
        end
      else
        return nil
      end
    end
  end
end
