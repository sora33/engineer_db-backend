#!/bin/bash
set -e
rm -f /myapp/tmp/pids/server.pid # サーバー起動時にpidファイルがあると起動できないので削除
# production環境の場合のみ
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:create || true # 初回のみ
  bundle exec rails db:migrate
  bundle exec rails db:seed || true # 初回のみ
fi

# コンテナのプロセスを実行
exec "$@"