# vimrc-generator-web
vimrc-generatorのフロントエンド兼APIリポジトリ

## SETUP
```
// cloneする
$ git clone git@bitbucket.org:itea_lab/vimrc-generator-web.git

// 依存関係にあるrubygemsをインストールする
$ bundle install --path vendor/bundle

// 依存関係にあるjavascriptライブラリをインストールする
$ bower install

// WEBサーバを起動する
$ bundle exec rackup --host 0.0.0.0

//以下のファイルのを設置する
$ cp config/config.yml.org config/config.yml
$ cp public/js/config.json.org public/js/config.json
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
