require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/config_file"
require 'logger'
require 'json'

config_file './config/config.yml'

before do
  @logger = Logger.new('./logs/vimrc-generator-web.log', 'daily')
end

get '/' do
  @web_host = settings.web_host
  @tty_host = settings.tty_host
  @tty_port = settings.tty_port
  erb :index
end

# vimrc書き込みAPI
post '/api/vimrc' do
  begin
    params = JSON.parse(request.body.read)

    if params['filepath'].nil?
      return [400, {"message" => "Required parameter `filepath` is missing"}.to_json]
    end

    if params['vimrc_contents'].nil?
      return [400, {"message" => "Required parameter `vimrc_contents` is missing"}.to_json]
    end

    if params['vimrc_contents'].class != Array
      return [400, {"message" => "Parameter `vimrc_contents` type must be Array"}.to_json]
    end

    unless File.exists?(params['filepath'])
      return [400, {"message" => "`#{params['filepath']}` does not exist"}.to_json]
    end

    File.open(params['filepath'], 'w') do |file|
      params['vimrc_contents'].each do |option|
        if VIMRC_SETTINGS[option]
          file.puts VIMRC_SETTINGS[option]
        else
          @logger.warn("Invalid settings passed: #{option}")
        end
      end
    end
  rescue JSON::ParserError => e
    @logger.error(e.message)
    return [400, {"message" => "RequestBody should be JSON object"}.to_json]
  rescue => e
    @logger.error(e.message)
    return [500, {"message" => "Unexpected Error"}.to_json]
  end

  @logger.info('success')
  return [201, {"filepath" => params['filepath'], "vimrc_contents" => params['vimrc_contents']}.to_json]
end
