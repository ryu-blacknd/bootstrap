#!/bin/sh

#
# Security
#
setenforce 0
sed -i -e 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

/sbin/iptables -F
/sbin/service iptables stop

#
# SSH
#
sed -i -e 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e 's/^#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config

#
# Stop Service
#
if [ -f '/etc/rc.d/init.d/iptables'  ]; then chkconfig iptables off;  fi
if [ -f '/etc/rc.d/init.d/ip6tables' ]; then chkconfig ip6tables off; fi
if [ -f '/etc/rc.d/init.d/iscsi'     ]; then chkconfig iscsi off;     fi
if [ -f '/etc/rc.d/init.d/iscsid'    ]; then chkconfig iscsid off;    fi
if [ -f '/etc/rc.d/init.d/netfs'     ]; then chkconfig netfs off;     fi
if [ -f '/etc/rc.d/init.d/udev-post' ]; then chkconfig udev-post off; fi

#
# yum repository
#
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi

#
# yum Install
#
yum --enablerepo=remi -y update
yum --enablerepo=remi -y groupinstall "Development Tools"
yum --enablerepo=remi -y install man lv w3m vim wget yum-cron openssl-devel readline-devel zlib-devel curl-devel libyaml-devel ImageMagick ImageMagick-devel ipa-pgothic-fonts ntp httpd httpd-devel mysql-server mysql-devel php php-cli php-pdo php-mbstring php-mcrypt php-mysql php-devel php-common php-pear php-gd php-xml php-pecl-xdebug php-pecl-imagick

chkconfig yum-cron on

#
# Shell & Editor
#
cd
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
cp -a ~/bootstrap/.vimrc ~
cp -a ~/bootstrap/.bashrc ~
cp -a ~/bootstrap/.dir_colors ~
cp -a ~/bootstrap/molokai.sh ~
chmod 755 ~/molokai.sh

#
# Git
#
git config --global http.sslverify false
useradd devuser -p devuser
mkdir /var/repos
chown devuser. /var/repos

#
# Sudoers
#
sed -i -e 's/^Defaults    requiretty/#Defaults    requiretty/' /etc/sudoers
echo "\n\ndevuser ALL = NOPASSWD: /usr/bin/git/" >> /etc/sudoers

#
# ntp
#
/sbin/chkconfig ntpd on
/sbin/service ntpd start

#
# Apache
#
/sbin/chkconfig httpd on

#
# PHP
#
sed -i -e "s/^\[Date\]$/[Date]\ndate.timezone = 'Asia\/Tokyo'/" /etc/php.ini

#
# MySQL
#
sed -i -e "s/^\[mysqld\]$/[mysqld]\ncharacter-set-server = utf8/" /etc/my.cnf
sed -i -e "s/^\[mysql\]$/[mysql]\ndefault-character-set = utf8/" /etc/my.cnf
sed -i -e "s/^\[mysqldump\]$/[mysqldump]\ndefault-character-set = utf8/" /etc/my.cnf
/sbin/chkconfig mysqld on
/sbin/service mysqld start
SQL="UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE redmine default character set utf8;
GRANT ALL on redmine.* to redmine IDENTIFIED BY 'redmine';
FLUSH PRIVILEGES;"
mysql -u root -e "$SQL"

#
# phpMyAdmin
#
cd
wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.0.8/phpMyAdmin-4.0.8-all-languages.zip
unzip phpMyAdmin-4.0.8-all-languages.zip -d /var/www/html
mv /var/www/html/phpMyAdmin-4.0.8-all-languages /var/www/html/phpmyadmin
chown -R apache. /var/www/html

#
# Ruby & bundler
#
yum -y remove ruby
yum -y remove ruby-*
mkdir src
cd src
curl -O ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz
tar zxvf ruby-1.9.3-p448.tar.gz
cd ruby-1.9.3-p448
./configure --disable-install-doc
make
make install
gem install bundler --no-rdoc --no-ri
cd ..

#
# Redmine
#
svn co http://svn.redmine.org/redmine/branches/2.3-stable /var/lib/redmine
CNF="production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: redmine
  password: redmine
  encoding: utf8
"
cat $CNF > /var/lib/redmine/configdatabase.yml
CNF="production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "localhost"
      port: 25
      domain: 'blacknd.dip.jp'

  rmagick_font_path: /usr/share/fonts/ipa-pgothic/ipagp.ttf
"
cat $CNF > /var/lib/redmine/config/configuration.yml
cd /var/lib/redmine
bundle install --without development test
bundle exec rake generate_secret_token
RAILS_ENV=production bundle exec rake db:migrate

#
# Passenger
#
gem install passenger --no-rdoc --no-ri
passenger-install-apache2-module
CNF="LoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-4.0.20/buildout/apache2/mod_passenger.so
PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-4.0.20
PassengerDefaultRuby /usr/local/bin/ruby

Header always unset "X-Powered-By"
Header always unset "X-Rack-Cache"
Header always unset "X-Content-Digest"
Header always unset "X-Runtime"

PassengerMaxPoolSize 20
PassengerMaxInstancesPerApp 4
PassengerPoolIdleTime 3600
PassengerHighPerformance on
PassengerStatThrottleRate 10
PassengerSpawnMethod smart
RailsAppSpawnerIdleTime 86400
PassengerMaxPreloaderIdleTime 0

RackBaseURI /redmine
"
cat $CNF > etc/httpd/conf.d/passenger.conf
chown -R apache. /var/lib/redmine
ln -s /var/lib/redmine/public /var/www/html/redmine

#
# Redmine themes
#
cd /var/lib/redmine/public/themes
git clone https://github.com/farend/redmine_theme_farend_fancy.git
git clone https://github.com/makotokw/redmine-theme-gitmike.git

#
# Redmine plugins
#
cd /var/lib/redmine/plugins

wget https://bitbucket.org/haru_iida/redmine_wiki_extensions/downloads/redmine_wiki_extensions-0.6.4.zip
unzip redmine_wiki_extensions-0.6.4.zip
bundle update
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

wget https://bitbucket.org/kusu/redmine_work_time/downloads/redmine_work_time-0.2.14.zip
unzip redmine_work_time-0.2.14.zip
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

git clone https://github.com/daipresents/redmine_parking_lot_chart.git
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

git clone https://github.com/alexbevi/redmine_knowledgebase.git
bundle update
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

#
# Start Service
#
/sbin/service httpd start
/sbin/service mysqld restart
