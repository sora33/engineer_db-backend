
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


## プロジェクトのテストコードドキュメント
### テストの方針

###　モックデータ
ファクトリーを使う。spec/factories/**

### 単体テスト
モデルスペックを使う。spec/models/**

###　結合テスト
viewを含めるときは、フィーチャー（システム）スペックを使う。
APIのようにJSONを返すときは、リクエストスペックを使う。spec/request/**

モデルスペックにモデルの単体テストを、リクエストスペックにAPIリクエストの結合テストを書いています。
モデルスペックでは、バリデーション、アソシエーション、メソッドのテストを行います。
結合テストでは、ユースケースに基づいて、正常系と異常系の動作を確認します。
正常系は、レスポンスのステータスとボディの確認をしています。
異常系は、認証エラー、not found、リクエストパラメータのバリデーションなどを確認しています。

### 工夫した点
テストコードの可読性を高めるために、subjectを使用してテスト対象を明確にしています。

factory_bot_rails
faker
shoulda-matchers

参考
https://qiita.com/KNR109/items/fe331069c4f958efbd96
