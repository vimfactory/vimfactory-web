# vimrc-generator-web
vimrc-generatorのフロントエンド&APIのリポジトリだよ！

## 動かす
- rbenvでRuby2.1.5をインストールする https://slack-files.com/T02MB4ECW-F03B44XJ6-7db7c4f39a
- bundlerをインストールする `gem install bundler`
- このリポジトリをgit cloneする
- gemをインストールする `bundle install`
- Webサーバを起動する `bundle exec rackup --host 0.0.0.0`
- これで動く
- `GET http://hostname:9292/`にアクセスするとトップページ
- `POST http://hostname:9292/api/vimrc`でAPIリクエスト

## WebAPI
webapiについての説明じゃ。  
1つしか無いがな。  

### POST /api/vimrc
#### リクエスト
- vimrc（ファイル）への書き込みを行う
- リクエストボディを使用する
- リクエストボディはJSON形式であること
- リクエストボディの構成
  - filepath
     - 書き込みファイルパス
     - 必須
     - 型：文字列
     - 存在しないファイルへの書き込みはできない
     - 例：'/home/mogulla3/.vimrc'
  - contents
     - 書き込むデータ。1要素1行。
     - 必須
     - 型：配列
     - 書き込み内容の妥当性はチェックしない
     - 例：['set number']

```
POST /api/vimrc
Content-Type: application/json
Host: ???

{
  "filepath": "/home/mogulla3/.vimrc",
  "contents": ["set number"]
}
```

#### レスポンス
書き込み成功 201 Created
```
{
  "filepath": "/home/mogulla3/.vimrc",
  "contents": ["set number"]
}
```

クライアントエラー 400 Bad Request
```
{
  "message": "[エラー内容に準じたメッセージ]"
}
```

サーバーエラー 500 Internal Server Error
```
{
  "message": "[エラー内容に準じたメッセージ]"
}
```
