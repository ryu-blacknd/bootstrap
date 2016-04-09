# CentOS 6 開発サーバ構築スクリプト

ローカル開発環境用に CentOS 6 (x86/64) の仮想サーバを構築し、開発環境を一発でセットアップするスクリプトです。

詳細は以下のブログで紹介しています。

[CentOS 6にLAMP, Git, Redmine, phpMyAdminな開発サーバを一発構築するスクリプト - BLACKND](http://blacknd.com/linux-server/centos-development-server-bootstrap-script/)

## 動作環境

- LAN 内のサーバ PC、または VirtualBox 等の仮想マシン (Vagrant 可)
- CentOS 6 x86/64 minimal iso イメージでのインストール直後であること

## インストール

rootでログインし、git をインストール後、取得した bootstrap.sh を実行するだけです。

~~~~
 # yum -y install git
 # cd
 # git clone https://github.com/ryu-blacknd/bootstrap.git
 # chmod +x bootstrap/bootstrap.sh
 # bootstrap/bootstrap.sh
~~~~

※その他、詳しい解説はブログ記事をご覧ください。
