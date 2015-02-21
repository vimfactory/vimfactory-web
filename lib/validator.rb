module VimFactory
  #
  # == バリデーションを行うクラス
  #
  class Validator
    # エラー情報
    attr_reader :error

    # @param [Hash{String =>(String, Fixnum, Boolean)}] vimrc_contents vimrc設定値
    def initialize(params = {})
      @vimrc_contents = params['vimrc_contents']
    end

    # バリデーションを行う
    # @return [Boolean] 成功時にTrue、失敗時にFalse
    def valid?
      if @vimrc_contents.nil?
        @error = 'Required parameter `vimrc_contents` is missing'
        return false
      end

      if @vimrc_contents.class != Hash
        @error = 'Type of `vimrc_contents` must be Hash'
        return false
      end

      true
    end
  end
end
