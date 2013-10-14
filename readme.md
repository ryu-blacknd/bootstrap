# CentOS6 開発サーバ構築スクリプト

ローカル開発環境用に CentOS 6.4 (x86/64) の仮想サーバを構築し、開発環境を一発でセットアップするスクリプトです。

詳細は以下のブログで紹介しています。

[CentOS6用 LAN内開発サーバ構築スクリプト - BLACKND](http://blacknd.com/linux-server/centos-development-server-bootstrap-script/)

## 動作環境

- LAN 内のサーバ PC、または VirtualBox 等の仮想マシン (Vagrant 可)
- CentOS x86/64 minimal iso イメージでのインストール直後であること

## インストール

rootでログインし、git をインストール後、取得した bootstrap.sh を実行するだけです。

~~~~
 # yum -y install git
 # cd
 # git clone https://github.com/ryu-blacknd/bootstrap.git
 # bootstrap/bootstrap.sh
~~~~

## 最初にすること

vim の初回起動時、以下を実行してプラグインをインストールしてください。

~~~~
:NeoBundleInstall
~~~~

root アカウントでログイン後、リブートを行います。

~~~~
 # reboot
~~~~

__※その他、詳しい解説はブログ記事をご覧ください。__

