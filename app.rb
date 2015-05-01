require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/assetpack'
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
  @basic_options = YAML.load_file('data/basic_options.yml')
  @colorscheme_options = YAML.load_file('data/colorscheme_options.yml')
  static_options  = VimFactory::VimrcOption::STATIC_OPTIONS
  @default_options = VimFactory::VimrcOption::DEFAULT_OPTIONS.merge(static_options)
  @connection_id = $cache.generate_uniqid
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

# 現在のvimrc取得API
post '/api/preview' do
  begin
    params = JSON.parse(request.body.read)

    vimrc_path = "#{settings.vimrc_dir}/vimrc_#{$cache.get(params['connection_id'])}"
    vimrc_preview = VimFactory::VimrcPreview.new(vimrc_path)
    vimrc = vimrc_preview.get
  rescue JSON::ParserError => e
    logger.error(e.message)
    return [400, { message: 'Requestbody should be JSON format' }.to_json]
  rescue => e
    logger.error(e.message)
    return [500, { message: 'Unexpected error' }.to_json]
  end

  logger.info('success')
  [200, { vimrc: vimrc }.to_json]
end
