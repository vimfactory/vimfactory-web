module VimFactory
  #
  # == VimrcCreatorが作成するvimrcの
  #    マスターとなる情報を保持するクラス
  #
  class VimrcOption
    # トグル形式のオプション
    # @example set number / set nonumber
    TOGGLE_OPTIONS = %w(
      ruler
      number
      autoindent
      cursorcolumn
      cursorline
      expandtab
      hlsearch
      ignorecase
      incsearch
      showmatch
      smartindent
      wildmenu
      wrap
      wrapscan
    )

    # 値が文字列形式のオプション
    # @example set encoding=utf8
    STRING_OPTIONS = {
      'encoding'   => %w(utf-8 sjis euc-jp euc-kr euc-cn latin1),
      'fileformat' => %w(dos unix mac),
      'syntax'     => %w(on off enable clear)
    }

    # 値が数値形式のオプション
    # @example set tabstop=1
    NUMBER_OPTIONS = {
      'matchtime'   => 0..100,
      'numberwidth' => 0..100,
      'scrolloff'   => 0..100,
      'shiftwidth'  => 0..100,
      'softtabstop' => 0..100,
      'tabstop'     => 0..100
    }

    # カラースキーマオプション
    # @exapmle colorscheme blue
    COLOR_SCHEMES = %w(
      blue
      darkblue
      default
      desert
      delek
      evening
      elflord
      industry
      koehler
      morning
      murphy
      peachpuff
      pablo
      ron
      shine
      slate
      torte
      zellner
    )

    # トグル形式のオプションか確認する
    # @param [String] option オプション名
    def self.toggle_option?(option)
      TOGGLE_OPTIONS.include?(option)
    end

    # 文字列形式のオプションか確認する
    # @param [String] option オプション名
    def self.string_option?(option)
      STRING_OPTIONS.include?(option)
    end

    # 数値形式のオプションか確認する
    # @param [String] option オプション名
    def self.number_option?(option)
      NUMBER_OPTIONS.include?(option)
    end
  end
end
