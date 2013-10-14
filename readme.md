# setup script for CentOS64

ローカル開発環境用の仮想サーバにCentOS64を利用する際に、開発環境を一発でセットアップするスクリプトです。

セキュリティ関係、LAMP (Apache, MySQL, PHP) 環境、Ruby on Rails環境を自動構築し、さらにphpMyAdminと、プロジェクト管理のRedmineも自動インストールします。

オマケとして、bash周りやvim周りもすぐに使い物になるよう環境構築します。

## 動作環境

- VirtualBox (Vagrantでつくった仮想マシンでも可）
- CentOS x86/64 minimal iso イメージでのインストール直後
- ネットワーク接続はNAT+ホストオンリーで設定済みであること

## 使い方

rootでログイン後、取得した bootstrap.sh を実行するだけです。

~~~~
# git clone https://github.com/ryu-blacknd/bootstrap.git
# bootstrap/bootstrap.sh
~~~~

ほぼノンストップで進んでいきますが、Passengerのインストール時のみ、画面に表示される通り Enter を押して進んでください。 (修正予定)

