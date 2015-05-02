module VimFactory
  require 'securerandom'
  require 'memcached'

  #
  # == Memcahcedクライアントのラッパークラス
  #
  class Cache
    attr_reader :uniqid

    # コンストラクタ
    # @param [String] servers 接続先サーバ
    # @return [void]
    def initialize(servers)
      @mem = Memcached.new(servers)
    end

    # Memcache上でユニークなIDを生成し、保存する
    def generate_uniqid
      @uniqid = SecureRandom.hex(8)
      begin
        loop do
          @uniqid = SecureRandom.hex(8)
          @mem.get(@uniqid)
        end
      rescue Memcached::NotFound => e
        @uniqid
      end
    end

    # Memcachedから値を取得する
    def get(key)
      @mem.get(key)
    end
  end
end
