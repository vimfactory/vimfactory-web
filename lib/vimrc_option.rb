require 'yaml'

module VimFactory
  # Vimrcの設定値を管理するクラス
  class VimrcOption
    TYPE = {
      toggle: 1,
      string: 2,
      number: 3,
      special: 4,
      color: 5,
      plugin: 6
    }

    class << self
      def type(option)
        case
        when toggle_option?(option) then TYPE[:toggle]
        when string_option?(option) then TYPE[:string]
        when number_option?(option) then TYPE[:number]
        when special_option?(option) then TYPE[:special]
        when color_option?(option) then TYPE[:color]
        when plugin_option?(option) then TYPE[:plugin]
        end
      end

      def initial_options
        load_option_file('initial')
      end

      def fixed_options
        load_option_file('fixed')
      end

      def toggle_options
        load_option_file('toggle')
      end

      def string_options
        load_option_file('string')
      end

      def number_options
        load_option_file('number')
      end

      def special_options
        load_option_file('special')
      end

      def color_options
        load_option_file('color')
      end

      def plugin_options
        load_option_file('plugin')
      end

      def toggle_option?(option)
        toggle_options.include?(option)
      end

      def string_option?(option)
        string_options.include?(option)
      end

      def number_option?(option)
        number_options.include?(option)
      end

      def special_option?(option)
        special_options.include?(option)
      end

      def color_option?(option)
        color_options.include?(option)
      end

      def plugin_option?(option)
        plugin_options.include?(option)
      end

      private

      def load_option_file(type)
        YAML.load_file(File.expand_path("./config/vimrc/#{type}_options.yml"))
      end
    end
  end
end
