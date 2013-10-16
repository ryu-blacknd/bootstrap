#!/bin/sh

#
# Stop SeLinux
#
echo -e "\033[0;32m[Stop selinux]\033[0;39m"
setenforce 0
sed -i -e 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

#
# Stop iptables
#
echo -e "\033[0;32m[Stop iptables]\033[0;39m"
/sbin/iptables -F
/sbin/service iptables stop

#
# SSH Setting
#
echo -e "\033[0;32m[SSH Setting]\033[0;39m"
# sed -i -e 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e 's/^#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config

#
# Stop Service
#
echo -e "\033[0;32m[Stop Service]\033[0;39m"
if [ -f '/etc/rc.d/init.d/iptables'  ]; then chkconfig iptables off;  fi
if [ -f '/etc/rc.d/init.d/ip6tables' ]; then chkconfig ip6tables off; fi
if [ -f '/etc/rc.d/init.d/iscsi'     ]; then chkconfig iscsi off;     fi
if [ -f '/etc/rc.d/init.d/iscsid'    ]; then chkconfig iscsid off;    fi
if [ -f '/etc/rc.d/init.d/netfs'     ]; then chkconfig netfs off;     fi
if [ -f '/etc/rc.d/init.d/udev-post' ]; then chkconfig udev-post off; fi

#
# yum repository
#
echo -e "\033[0;32m[yum repository]\033[0;39m"
rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi

#
# yum Install
#
echo -e "\033[0;32m[yum update]\033[0;39m"
yum --enablerepo=remi -y update

echo -e "\033[0;32m[yum install Development Tools]\033[0;39m"
yum --enablerepo=remi -y groupinstall "Development Tools"

echo -e "\033[0;32m[yum install others]\033[0;39m"
yum --enablerepo=remi -y install expect mlocate man finger w3m vim wget yum-cron openssl-devel readline-devel zlib-devel curl-devel libyaml-devel ImageMagick ImageMagick-devel ipa-pgothic-fonts ntp httpd httpd-devel mysql-server mysql-devel php php-cli php-pdo php-mbstring php-mcrypt php-mysql php-devel php-common php-pear php-gd php-xml php-pecl-xdebug php-pecl-imagick

chkconfig yum-cron on

#
# Shell & Editor
#
echo -e "\033[0;32m[Shell & Editor]\033[0;39m"
cd
mkdir -p ~/.vim/bundle
git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
cp -a ~/bootstrap/.vimrc ~
cp -a ~/bootstrap/.bashrc ~
cp -a ~/bootstrap/.dir_colors ~
cp -a ~/bootstrap/molokai.sh ~
chmod 755 ~/molokai.sh
source ~/.bashrc

#
# Git
#
echo -e "\033[0;32m[Git]\033[0;39m"
git config --global http.sslverify false
useradd gituser
echo "gituser" | passwd --stdin gituser
mkdir /home/gituser/.ssh
touch /home/gituser/.ssh/authorized_keys
chown gituser. /home/gituser/.ssh/authorized_keys
chmod 600 /home/gituser/.ssh/authorized_keys
mkdir /var/repos
chown gituser. /var/repos
chown gituser. /var/www/html

#
# Sudoers
#
# echo -e "\033[0;32m[Sudoers]\033[0;39m"
# sed -i -e 's/^Defaults    requiretty/#Defaults    requiretty/' /etc/sudoers
# echo "gituser ALL = NOPASSWD: /usr/bin/git" >> /etc/sudoers

#
# ntp
#
echo -e "\033[0;32m[Start ntp]\033[0;39m"
/sbin/chkconfig ntpd on
/sbin/service ntpd start

#
# Apache
#
/sbin/chkconfig httpd on

#
# PHP
#
echo -e "\033[0;32m[PHP Setting]\033[0;39m"
sed -i -e "s/^\[Date\]$/[Date]\ndate.timezone = 'Asia\/Tokyo'/" /etc/php.ini

#
# MySQL
#
echo -e "\033[0;32m[MySQL Setting]\033[0;39m"
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
echo -e "\033[0;32m[phpMyAdmin Install]\033[0;39m"
cd
wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.0.8/phpMyAdmin-4.0.8-all-languages.zip
unzip phpMyAdmin-4.0.8-all-languages.zip -d /var/www/html
mv /var/www/html/phpMyAdmin-4.0.8-all-languages /var/www/html/phpmyadmin
chown -R apache. /var/www/html/*

#
# Ruby & bundler
#
echo -e "\033[0;32m[Ruby Install]\033[0;39m"
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
echo -e "\033[0;32m[Redmine Install]\033[0;39m"
svn co http://svn.redmine.org/redmine/branches/2.3-stable /var/lib/redmine
cp -a ~/bootstrap/database.yml /var/lib/redmine/config/database.yml
cp -a ~/bootstrap/configdatabase.yml /var/lib/redmine/config/configuration.yml
cd /var/lib/redmine
bundle install --without development test
bundle exec rake generate_secret_token
RAILS_ENV=production bundle exec rake db:migrate

#
# Passenger
#
echo -e "\033[0;32m[Passenger Install]\033[0;39m"
gem install passenger --no-rdoc --no-ri
expect -c "
set timeout -1 
spawn passenger-install-apache2-module
expect \"Press Enter to continue, or Ctrl-C to abort.\"
send \"\n\"
expect \"Press ENTER to continue.\"
send \"\n\"
"
cp -a ~/bootstrap/passenger.conf /etc/httpd/conf.d/passenger.conf
chown -R apache. /var/lib/redmine
ln -s /var/lib/redmine/public /var/www/html/redmine

#
# Redmine themes
#
echo -e "\033[0;32m[Redmine themes]\033[0;39m"
cd /var/lib/redmine/public/themes
git clone https://github.com/farend/redmine_theme_farend_basic.git
git clone https://github.com/farend/redmine_theme_farend_fancy.git
git clone git://github.com/makotokw/redmine-theme-gitmike.git gitmike
cd gitmike
git checkout -b ja r4_japanese_font

#
# Redmine plugins
#
echo -e "\033[0;32m[Redmine plugins]\033[0;39m"
cd /var/lib/redmine/plugins

wget https://bitbucket.org/haru_iida/redmine_wiki_extensions/downloads/redmine_wiki_extensions-0.6.4.zip
unzip redmine_wiki_extensions-0.6.4.zip
bundle update
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

gem install --version 2.0.0b5 redcarpet
git clone https://github.com/alminium/redmine_redcarpet_formatter.git
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

wget https://bitbucket.org/kusu/redmine_work_time/downloads/redmine_work_time-0.2.14.zip
unzip redmine_work_time-0.2.14.zip
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

git clone https://github.com/vividtone/redmine_vividtone_my_page_blocks.git
bundle exec rake redmine:plugins:migrate RAILS_ENV=production

# wget https://bitbucket.org/haru_iida/redmine_code_review/downloads/redmine_code_review-0.6.3.zip
# unzip redmine_code_review-0.6.3.zip
# bundle update
# bundle exec rake redmine:plugins:migrate RAILS_ENV=production

# git clone https://github.com/daipresents/redmine_parking_lot_chart.git
# bundle exec rake redmine:plugins:migrate RAILS_ENV=production

#
# Start Service
#
echo -e "\033[0;32m[Start Service]\033[0;39m"
/sbin/service httpd start
/sbin/service mysqld restart

