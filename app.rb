require 'sinatra'
require 'sinatra/reloader' if development?
require 'logger'
require 'json'

before do
  @logger = Logger.new('./logs/vimrc-generator-web.log', 'daily')
end

get '/' do
  erb :index
end

# vimrc書き込みAPI
post '/api/vimrc' do
  begin
    params = JSON.parse(request.body.read)

    if params['filepath'].nil?
      return [400, {"message" => "Required parameter `filepath` is missing"}.to_json]
    end

    if params['contents'].nil?
      return [400, {"message" => "Required parameter `contents` is missing"}.to_json]
    end

    if params['contents'].class != Array
      return [400, {"message" => "Parameter `contents` type must be Array"}.to_json]
    end

    unless File.exists?(params['filepath'])
      return [400, {"message" => "`#{params['filepath']}` does not exist"}.to_json]
    end

    File.open(params['filepath'], 'a') do |file|
      params['contents'].each do |content|
        file.puts content
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
  return [201, {"filepath" => params['filepath'], "contents" => params['contents']}.to_json]
end
