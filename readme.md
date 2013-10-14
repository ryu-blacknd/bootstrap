# setup script for CentOS64

ローカル開発環境用にCentOS64の仮想サーバを利用する際に、開発環境を一発でセットアップするスクリプトです。

NetBeans → ローカルGitリポジトリ → リモートベアリポジトリ → 本番環境リポジトリで自動pull、という開発フローを想定しています。

セキュリティ関係、LAMP (Apache, MySQL, PHP) 、Ruby等の環境を自動構築し、さらにphpMyAdminと、プロジェクト管理のRedmineも自動インストールします。

オマケとして、bash周りやvim周りもすぐに使い物になるよう環境構築します。

## 動作環境

- VirtualBox (Vagrantでつくった仮想マシンでも可）
- CentOS x86/64 minimal iso イメージでのインストール直後
- ネットワーク接続はNAT+ホストオンリーで設定済みであること

## 使い方

rootでログイン後、もしインストールしていなければ git をインストール後、取得した bootstrap.sh を実行するだけです。

~~~~
# yum -y install git
# cd
# git clone https://github.com/ryu-blacknd/bootstrap.git
# bootstrap/bootstrap.sh
~~~~

ほぼノンストップで進んでいきますが、Passengerのインストール時のみ、画面に表示される通り Enter を押して進んでください。 (修正予定)

