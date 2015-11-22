require_relative './vimrc_option'

module VimFactory
  # Vimrcを生成するクラス
  class VimrcCreator
    def initialize(vimrc_contents, filepath)
      @vimrc_contents = vimrc_contents || {}
      @filepath = filepath.to_s
    end

    def create
      File.open(@filepath, 'w') do |file|
        @vimrc_contents.merge(VimrcOption.fixed_options).each do |option, value|
          line = build_option_line(option, value)
          file.puts(line) if line.nil? == false
        end
      end
    end

    private

    def build_option_line(option, value)
      case VimrcOption.type(option)
      when VimrcOption::TYPE[:toggle]
        toggle_option_line(option, value)
      when VimrcOption::TYPE[:string]
        string_option_line(option, value)
      when VimrcOption::TYPE[:number]
        number_option_line(option, value)
      when VimrcOption::TYPE[:special]
        special_option_line(option)
      when VimrcOption::TYPE[:color]
        color_option_line(option, value)
      end
    end

    def toggle_option_line(option, value)
      "set #{option}" if value == true
    end

    def string_option_line(option, value)
      "set #{option}=#{value}" if VimrcOption.string_options[option].include?(value)
    end

    def number_option_line(option, value)
      return nil if value.nil? || value == ''
      "set #{option}=#{value.to_i}" if VimrcOption.number_options[option].include?(value.to_i)
    end

    def color_option_line(option, value)
      "#{option} #{value}" if VimrcOption.color_options[option].include?(value)
    end

    def special_option_line(option)
      VimrcOption.special_options[option]
    end
  end
end
