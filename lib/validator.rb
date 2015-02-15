module VimFactory
  class Validator
    attr_reader :error
    attr_accessor :id, :vimrc_contents

    def initialize(params = {})
      @id = params['id']
      @vimrc_contents = params['vimrc_contents']
    end

    def valid?
      if @id.nil?
        @error = 'Required parameter `id` is missing'
        return false
      end

      if @vimrc_contents.nil?
        @error = 'Required parameter `vimrc_contents` is missing'
        return false
      end

      true
    end
  end
end
