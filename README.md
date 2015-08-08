# vimfactory-web
vimfactoryのフロントエンド兼APIリポジトリ

## SETUP
```
// cloneする
$ git clone git@gitlab.com:vimfactory/vimfactory-web.git

// 依存関係にあるrubygemsをインストールする
$ bundle install --path vendor/bundle

// 依存関係にあるjavascriptライブラリをインストールする
$ bower install

// WEBサーバを起動する
$ bundle exec rackup --host 0.0.0.0
```

### bundler自体のインストール
Rubyのインストールを前提とする。
bundlerはシステムグローバルにインストールする。
```
$ sudo gem install bundler
```

### bower自体のインストール
Nodejsとnpmのインストールを前提とする。
bowerはシステムグローバルにインストールする。
```
$ sudo npm install bower -g
```

### rubocopをつかった静的解析
commit/push前にチェック
```
// 全コードチェック
$ bundle exec rubocop .
```

### ユニットテスト
commit/push前にチェック
```
// テスト実行
$ bundle exec ruby tests/[テストしたいファイル].rb
```

### sassコンパイル
```
$ bundle exec sass sass/main.sass ./public/css/butterfly.css
```
