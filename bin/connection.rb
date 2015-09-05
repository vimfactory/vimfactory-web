require 'yaml'
require 'logger'
require 'docker'
require 'memcached'

# logger setting
log_path = File.expand_path("../../logs", __FILE__)
logger = Logger.new("#{log_path}/docker_connect.log")

connection_id = ARGV[0]
if connection_id.empty?
  logger.error("No connection_id.")
  exit
end

# memcached
cache = Memcached.new("localhost:11211")
begin
  cache.get(connection_id)
  logger.error("[#{connection_id}] Container is alredy created.")
  exit
rescue Memcached::NotFound => e
  logger.info("[#{connection_id}] Container is not created.")
end

# docker
begin
  failed ||= 0

  #コンテナ作成
  docker_config = YAML::load_file("./config/docker_option.yml")
  container = Docker::Container.create(docker_config)
  container_id = container.json["Id"][0,12]
  logger.info("[#{connection_id}] Create container(#{container_id}).")

  #コンテナ起動
  container.start
  logger.info("[#{connection_id}] Container(#{container_id}) started.")

  #memcachedに登録
  cache.set(connection_id, container_id)
  logger.info("[#{connection_id}] Register container_id(#{container_id}) and connection_id with cache.")

  #コンテナへアクセス(attach)
  #container.attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true, :logs => true, :tty => true)
  system("docker attach --sig-proxy=false #{container_id}")
rescue Docker::Error::DockerError => e
  failed += 1
  logger.error("[Failed #{failed}:] #{e.message}")
  if failed < 3
    sleep(1)
    retry
  end
end
