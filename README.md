[![build status](https://gitlab.com/ci/projects/3269/status.png?ref=master)](https://gitlab.com/ci/projects/3269?ref=master)

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
$ bundle exec rake rubocop
```

### ユニットテスト
commit/push前にチェック
```
// テスト実行
$ bundle exec rake test
// 詳細表示にしたい場合
$ bundle exec rake test TESTOPTS="-v"
```

### sassコンパイル
```
$ bundle exec rake compile_sass
```

### coffeeコンパイル
```
$ bundle exec rake compile_coffee_script
```

## Guard起動
coffeescriptコンパイル、sassコンパイル、テスト、rubocop起動を行う
```
$ bundle exec guard start
```
