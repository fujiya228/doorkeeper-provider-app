#!/bin/bash

# ホストで使っているユーザとコンテナで使っているユーザで UID と GID の不一致があると、パーミッションの問題が生じる
# Dockerコンテナ上にpublic-userというユーザーを用意してあるので、public-userをホスト側のユーザーと合わせることで解消する
LOCAL_UID=$(id -u $USER)
LOCAL_GID=$(id -g $USER)
base='docker-compose run --rm -e $LOCAL_UID -e $LOCAL_GID web'
exec $base $*

# setup
# ./sh rails new . --force --no-deps --database=postgresql --skip-test --skip-bundle
# ./sh bundler
# ./sh rails webpacker:install
# docker-compose build
# cp config/database.yml.default config/database.yml
# ./sh rake db:create
# docker-compose up