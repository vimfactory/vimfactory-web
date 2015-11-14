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
      list
      showmatch
      showcmd
      smartindent
      spell
      wildmenu
      wrap
      wrapscan
    )

    # 値が文字列形式のオプション
    # @example set encoding=utf8
    STRING_OPTIONS = {
      'encoding'      => %w(utf-8 sjis euc-jp euc-kr euc-cn latin1),
      'fileformat'    => %w(dos unix mac),
      'fileformats'   => %w(unix,dos,mac),
      'fileencodings' => %w(utf-8)
    }

    # 値が数値形式のオプション
    # @example set tabstop=1
    NUMBER_OPTIONS = {
      'matchtime'   => 0..100,
      'numberwidth' => 0..100,
      'scrolloff'   => 0..100,
      'shiftwidth'  => 0..100,
      'softtabstop' => 0..100,
      'tabstop'     => 0..100,
      't_Co'        => 256..256
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
      molokai
      jellybeans
      solarized
      hybrid
      railscasts
    )

    # 特殊形式オプション
    # 値をそのまま使う
    SPECIAL_OPTIONS = {
      'syntax_on' => 'syntax on',
      'syntax_off' => 'syntax off',
      'syntax_enable' => 'syntax enable',
      'syntax_clear' => 'syntax clear',
      'filetype_on' => 'filetype on',
      'filetype_off' => 'filetype off',
      'filetype_indent_on' => 'filetype indent on',
      'filetype_plugin_indent_on' => 'filetype plugin indent on'
    }

    # 初期設定オプション
    INITIAL_OPTIONS = {
      'colorscheme' => 'molokai'
    }

    # 固定（変更不可かつ必ず設定される）オプション
    FIXED_OPTIONS = {
      't_Co' => 256,
      'fileformats' => 'unix,dos,mac',
      'encoding' => 'utf-8',
      'fileencodings' => 'utf-8',
      'syntax_on' => true
    }

    # トグル形式のオプションか確認する
    # @param [String] option オプション名
    # @return [Boolean] トグル形式のオプションであればtrue、そうでなければfalse
    def self.toggle_option?(option)
      TOGGLE_OPTIONS.include?(option)
    end

    # 文字列形式のオプションか確認する
    # @param [String] option オプション名
    # @return [Boolean] 文字列形式のオプションであればtrue、そうでなければfalse
    def self.string_option?(option)
      STRING_OPTIONS.include?(option)
    end

    # 数値形式のオプションか確認する
    # @param [String] option オプション名
    # @return [Boolean] 数値形式のオプションであればtrue、そうでなければfalse
    def self.number_option?(option)
      NUMBER_OPTIONS.include?(option)
    end

    # 特殊形式のオプションか確認する
    # @param [String] option オプション名
    # @return [Boolean] 特殊形式のオプションであればtrue、そうでなければfalse
    def self.special_option?(option)
      SPECIAL_OPTIONS.include?(option)
    end
  end
end
