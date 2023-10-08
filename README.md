
 ## 使用するコマンド
- docker compose run api bundle exec rubocop -A
- docker compose run api bundle install
- docker compose run api rails db:create
- docker compose run api rails db:migrate

https://blog.furu07yu.com/entry/rails7-devise-token-auth
## devise_token_authの実装
- docker compose run api rails g devise:install
- docker compose run api rails g devise_token_auth:install User auth

## uuidにしたい