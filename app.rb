require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/assetpack'
require 'sinatra/r18n'
require 'json'
require 'memcached'
require 'yaml'
require './lib/validator'
require './lib/vimrc_creator'
require './lib/vimrc_preview'
require './lib/vimrc_option'
require './lib/cache'

configure do
  enable :logging
  config_file './config/config.yml'
  $cache = VimFactory::Cache.new('localhost:11211')
end

before do
  session[:locale] = 'ja'
  @locale = 'ja'
end

before '/en/*' do
  session[:locale] = 'en'
  @locale = 'en'
  request.path_info = '/' + params[:splat][0]
end

assets do
  serve '/js', from: 'public/js'
  serve '/css', from: 'public/css'
  serve '/bower_components', from: 'bower_components'

  js :app, [
    '/bower_components/jquery/dist/jquery.min.js',
    '/bower_components/jquery.blockUI.js/jquery.blockUI.js',
    '/bower_components/bootstrap/dist/js/bootstrap.min.js',
    '/bower_components/socket.io-client/dist/socket.io.min.js',
    '/bower_components/term/index.js',
    '/js/index.js',
    '/js/tty.js'
  ]

  css :app, '/css/app.css', [
    '/css/*.css'
  ]

  css :libs, [
    '/bower_components/bootstrap/dist/css/bootstrap.min.css'
  ]

  js_compression :simple
  css_compression :simple
end

get '/' do
  @top_msg = t.top
  @settings_msg = t.settings
  @basic_options = YAML.load_file(settings.basic_options_path)
  @colorscheme_options = YAML.load_file(settings.colorscheme_options_path)
  @programlang_options = YAML.load_file(settings.programlang_options_path)
  @initial_options = File.read(settings.vimrc_default_path).split("\n")
  @connection_id = $cache.generate_uniqid
  erb :index
end

get '/hosting/:user_id' do |id|
  erb :hosting
end

get '/test' do
  session[:locale]
end

# vimrc作成
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
      "#{settings.vimrc_dir}/vimrc_#{$cache.get(params['connection_id'])}"
    )
    vimrc_creator.create
  rescue JSON::ParserError => e
    logger.error(e.message)
    return [400, { message: 'Requestbody should be JSON format' }.to_json]
  rescue => e
    logger.error(e.message)
    return [500, { message: 'Unexpected error' }.to_json]
  end

  logger.info('success')
  [201, { vimrc_contents: params['vimrc_contents'] }.to_json]
end

# vimrc取得
get '/api/vimrc/:connection_id' do |id|
  begin
    vimrc_path = "#{settings.vimrc_dir}/vimrc_#{$cache.get(id)}"
    vimrc_preview = VimFactory::VimrcPreview.new(vimrc_path)
    vimrc = vimrc_preview.get
  rescue Memcached::NotFound => e
    logger.error(e.message)
    return [404, { message: 'Vimrc is not found.' }.to_json]
  rescue => e
    logger.error(e.message)
    return [500, { message: 'Unexpected error' }.to_json]
  end

  logger.info('success')
  [200, { vimrc: vimrc }.to_json]
end
