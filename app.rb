require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/config_file'
require 'sinatra/assetpack'
require 'logger'
require 'json'
require 'securerandom'
require './lib/validator'
require './lib/vimrc_creator'

config_file './config/config.yml'

enable :sessions

before do
  @logger = Logger.new('./logs/vimrc-generator-web.log', 'daily')
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
  @tmp_id   = SecureRandom.base64(8)
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
      return [400, { message: validator.error }.to_json]
    end

    # vimrc作成
    vimrc_creator = VimFactory::VimrcCreator.new(
      params['vimrc_contents'],
      "#{settings.vimrc_dir}/vimrc_xxxxx" # TODO: idはmemcachedから取得する
    )
    vimrc_creator.create
  rescue JSON::ParserError => e
    @logger.error(e.message)
    return [400, { message: 'Requestbody should be JSON format' }.to_json]
  rescue => e
    @logger.error(e.message)
    return [500, { message: 'Unexpected error' }.to_json]
  end

  @logger.info('success')
  [201, { vimrc_contents: params['vimrc_contents'] }.to_json]
end
