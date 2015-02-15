require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/config_file'
require 'sinatra/assetpack'
require 'logger'
require 'json'
require 'securerandom'
require './lib/validator'

config_file './config/config.yml'

enable :sessions

before do
  @logger = Logger.new('./logs/vimrc-generator-web.log', 'daily')

  session[:tmp_id] = SecureRandom.base64(8) if session[:tmp_id].nil?
end

assets do
  serve '/js', from: 'public/js'
  serve '/css', from: 'public/css'
  serve '/bower_components', from: 'bower_components'

  js :app, '/js/app.js', [
    '/js/*.js'
  ]

  js :libs, [
    '/bower_components/jquery/dist/jquery.min.js',
    '/bower_components/socket.io-client/dist/socket.io.min.js',
    '/bower_components/term/index.js'
  ]

  css :app, '/css/app.css', [
    '/css/*.css'
  ]

  js_compression :jsmin
  css_compression :simple
end

get '/' do
  @tmp_id   = session[:tmp_id]
  @web_host = settings.web_host
  @tty_host = settings.tty_host
  erb :index
end

# vimrc書き込みAPI
post '/api/vimrc' do
  begin
    params = JSON.parse(request.body.read)

    # バリデーション
    validator = VimFactory::Validator.new(params)
    if validator.valid? == false
      return [400, { 'message' => validator.error }.to_json]
    end

    vimrc = settings.vimrc_dir + '/vimrc_' + params['id']
    File.open(vimrc, 'w') do |file|
      params['vimrc_contents'].each do |key, val|
        # 値がfalseあるいは空の時にはスキップ
        next if val == false || val == ''

        # 値チェックのバリデーション

        # colorchemeオプション
        if key == 'colorscheme'
          file.puts 'syntax on'
          file.puts "colorscheme #{val}"
          next
        end

        # true or falseのオプション
        if val == true
          file.puts "set #{key}"
          next
        end

        # 値があるオプション
        file.puts "set #{key}=#{val}"
      end
    end

  rescue JSON::ParserError => e
    @logger.error(e.message)
    return [400, { 'message' => 'RequestBody should be JSON object' }.to_json]
  rescue => e
    @logger.error(e.message)
    return [500, { 'message' => 'Unexpected Error' }.to_json]
  end

  @logger.info('success')
  return [201, { 'filepath' => params['filepath'], 'vimrc_contents' => params['vimrc_contents'] }.to_json]
end
