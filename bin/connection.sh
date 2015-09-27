#!/bin/sh

#vimfactory-webまで移動
cd `dirname $0`
cd ../

# load config
source ./config/docker/connection_sh.conf

# serviceコマンド経由で実行すると環境変数が引き継げないので
export PATH=/usr/local/bin:$PATH
export DOCKER_HOST=$DOCKER_HOST

bundle exec ruby ./bin/connection.rb $1
