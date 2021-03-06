#!/bin/sh
cp -r Packages/* /usr/local/src
cp -r Conf /usr/local/src/
#setup_start
#SELINUX
sed -i 's/SELINUX=enforcing/#SELINUX=enforcing/g' /etc/selinux/config
sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config
sed -i '$a SELINUX=disabled' /etc/selinux/config
setenforce 0 
#yum
yum install -y apr* autoconf automake bison bzip2 bzip2* cloog-ppl compat* cpp curl curl-devel fontconfig fontconfig-devel freetype freetype* freetype-devel gcc gcc-c++ gtk+-devel gd gettext gettext-devel glibc kernel kernel-headers keyutils keyutils-libs-devel krb5-devel libcom_err-devel libpng libpng* libpng-devel libjpeg* libsepol-devel libselinux-devel libstdc++-devel libtool* libgomp libxml2 libxml2-devel libXpm* libX* libtiff libtiff*  make mpfr ncurses* ntp openssl nasm nasm* openssl-devel patch pcre-devel perl php-common php-gd policycoreutils ppl telnet t1lib t1lib*  wget zlib-devel
#yum centos 7
yum install -y apr* autoconf automake bison bzip2 bzip2* cloog-ppl compat* cpp curl curl-devel fontconfig fontconfig-devel freetype freetype* freetype-devel gcc gcc-c++ gtk+-devel gd gettext gettext-devel glibc kernel kernel-headers keyutils keyutils-libs-devel krb5-devel libcom_err-devel libpng libpng-devel libjpeg* libsepol-devel libselinux-devel libstdc++-devel libtool* libgomp libxml2 libxml2-devel libXpm* libtiff libtiff* make mpfr ncurses* ntp openssl openssl-devel patch pcre-devel perl php-common php-gd policycoreutils telnet t1lib t1lib* nasm nasm* wget zlib-devel
#date
/usr/sbin/ntpdate cn.pool.ntp.org
#setup_end
#mysql_start
#cmake
cd /usr/local/src
tar zxvf cmake-3.0.2.tar.gz
cd cmake-3.0.2
./configure
make && make install
#mysql
groupadd mysql
useradd -g mysql mysql -s /bin/false
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql
mkdir -p /usr/local/mysql
cd /usr/local/src
tar zxvf mysql-5.6.22.tar.gz
cd mysql-5.6.22
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql  -DMYSQL_DATADIR=/data/mysql  -DSYSCONFDIR=/etc  -DENABLE_DOWNLOADS=1
make
make install
rm -rf /etc/my.cnf
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql
ln -s /usr/local/mysql/my.cnf /etc/my.cnf
cp ./support-files/mysql.server  /etc/rc.d/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig mysqld on
echo 'basedir=/usr/local/mysql/' >> /etc/rc.d/init.d/mysqld
echo 'datadir=/data/mysql/' >>/etc/rc.d/init.d/mysqld
echo 'export PATH=$PATH:/usr/local/mysql/bin' >> /etc/profile
source  /etc/profile
mkdir /usr/local/mysql/lib/mysql
ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql
mkdir /var/lib/mysql
ln -s /tmp/mysql.sock  /var/lib/mysql/mysql.sock
#512M VPS
rm -rf /data/mysql/*
echo 'innodb_buffer_pool_size = 32M' >> /usr/local/mysql/my.cnf
cd /usr/local/mysql
./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql
service mysqld start
#mysql_end
#nginx_start
#pcre
cd /usr/local/src
mkdir /usr/local/pcre
tar zxvf pcre-8.36.tar.gz
cd pcre-8.36
./configure --prefix=/usr/local/pcre
make && make install
#openssl
cd /usr/local/src
mkdir /usr/local/openssl
tar zxvf openssl-1.0.1j.tar.gz
cd openssl-1.0.1j
./config --prefix=/usr/local/openssl
make && make install
echo 'export PATH=$PATH:/usr/local/openssl/bin' >> /etc/profile
source  /etc/profile
#zlib
cd /usr/local/src
mkdir /usr/local/zlib
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=/usr/local/zlib
make && make install
#libunwind
cd /usr/local/src
tar zxvf libunwind-1.1.tar.gz
cd libunwind-1.1
./configure
make && make install
#nginx
groupadd www
useradd -g www www -s /bin/false
cd /usr/local/src
tar zxvf nginx-1.6.2.tar.gz
cd nginx-1.6.2
./configure --prefix=/usr/local/nginx  --without-http_memcached_module --user=www --group=www --with-http_stub_status_module --with-http_sub_module  --with-http_ssl_module  --with-http_gzip_static_module  --with-openssl=/usr/local/src/openssl-1.0.1j --with-zlib=/usr/local/src/zlib-1.2.8 --with-pcre=/usr/local/src/pcre-8.36
make && make install
/usr/local/nginx/sbin/nginx
cp /usr/local/src/Conf/nginx  /etc/rc.d/init.d/nginx
chmod 775 /etc/rc.d/init.d/nginx
chkconfig nginx on
/etc/rc.d/init.d/nginx restart
#nginx_end
#php_start
#yasm
cd  /usr/local/src
tar zxvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure
make && make install
#libmcrypt
cd /usr/local/src
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8
./configure
make && make install
#libvpx
cd  /usr/local/src
tar xvf libvpx-v1.3.0.tar.bz2
cd libvpx-v1.3.0
./configure --prefix=/usr/local/libvpx --enable-shared --enable-vp9
make && make install
#tiff
cd  /usr/local/src
tar zxvf tiff-4.0.3.tar.gz
cd tiff-4.0.3
./configure --prefix=/usr/local/tiff --enable-shared
make && make install
#libpng
cd  /usr/local/src
tar zxvf libpng-1.6.15.tar.gz
cd libpng-1.6.15
./configure  --prefix=/usr/local/libpng --enable-shared
make && make install
#freetype
cd  /usr/local/src
tar zxvf freetype-2.5.4.tar.gz
cd  freetype-2.5.4
./configure --prefix=/usr/local/freetype --enable-shared -without-png
make && make install
#jpeg
cd  /usr/local/src
tar zxvf jpegsrc.v9a.tar.gz
cd jpeg-9a
./configure --prefix=/usr/local/jpeg --enable-shared
make && make install
#libgd
cd /usr/local/src
tar zxvf libgd-2.1.0.tar.gz
cd libgd-2.1.0
./configure  --prefix=/usr/local/libgd  --enable-shared  --with-jpeg=/usr/local/jpeg  --with-png=/usr/local/libpng  --with-freetype=/usr/local/freetype  --with-fontconfig=/usr/local/freetype  --with-tiff=/usr/local/tiff  --with-vpx=/usr/local/libvpx  --with-xpm=/usr/
make && make install
#t1lib
cd /usr/local/src
tar zxvf t1lib-5.1.2.tar.gz
cd t1lib-5.1.2
./configure --prefix=/usr/local/t1lib --enable-shared
make without_doc && make install
#libiconv
cd /usr/local/src
tar zxvf libiconv-1.14.tar.gz
cd libiconv-1.14
./configure --prefix=/usr/local/libiconv
make && make install
#php
mv /usr/lib/libltdl.so  /usr/lib/libltdl.so-bak
\cp -frp /usr/lib64/libltdl.so*  /usr/lib/
\cp -frp /usr/lib64/libXpm.so*   /usr/lib/
export LD_LIBRARY_PATH=/usr/local/libgd/lib
cd /usr/local/src
tar -zvxf php-5.6.3.tar.gz
cd php-5.6.3
sed -i 's/return "unknown";/ return "9a";/g' /usr/local/src/php-5.6.3/ext/gd/libgd/gd_jpeg.c
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/mysql --with-gd --with-png-dir=/usr/local/libpng --with-jpeg-dir=/usr/local/jpeg --with-freetype-dir=/usr/local/freetype --with-xpm-dir=/usr/ --with-vpx-dir=/usr/local/libvpx/ --with-zlib-dir=/usr/local/zlib --with-t1lib=/usr/local/t1lib --with-iconv --enable-libxml --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-opcache --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --enable-ctype --disable-fileinfo
make && make install
cp php.ini-production /usr/local/php/etc/php.ini
rm -rf /etc/php.ini
ln -s /usr/local/php/etc/php.ini /etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default  /usr/local/php/etc/php-fpm.conf
ln -s /usr/local/php/etc/php-fpm.conf /etc/php-fpm.conf
cp /usr/local/src/php-5.6.3/sapi/fpm/init.d.php-fpm  /etc/rc.d/init.d/php-fpm
chmod +x /etc/rc.d/init.d/php-fpm
chkconfig php-fpm on
sed -i '/\[global\]/a pid = run/php-fpm.pid' /usr/local/php/etc/php-fpm.conf
sed -i 's/user = nobody/ user = www /g' /usr/local/php/etc/php-fpm.conf
sed -i 's/group = nobody/ group = www /g' /usr/local/php/etc/php-fpm.conf
sed -i 's/;date.timezone =/ date.timezone = PRC /g' /usr/local/php/etc/php.ini
sed -i 's/expose_php = On/ expose_php = Off /g' /usr/local/php/etc/php.ini
sed -i 's/short_open_tag = Off/ short_open_tag = On /g' /usr/local/php/etc/php.ini
sed -i 's/disable_functions =/ disable_functions = passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,escapeshellcmd,dll,popen,disk_free_space,checkdnsrr,checkdnsrr,getservbyname,getservbyport,disk_total_space,posix_ctermid,posix_get_last_error,posix_getcwd, posix_getegid,posix_geteuid,posix_getgid, posix_getgrgid,posix_getgrnam,posix_getgroups,posix_getlogin,posix_getpgid,posix_getpgrp,posix_getpid, posix_getppid,posix_getpwnam,posix_getpwuid, posix_getrlimit, posix_getsid,posix_getuid,posix_isatty, posix_kill,posix_mkfifo,posix_setegid,posix_seteuid,posix_setgid, posix_setpgid,posix_setsid,posix_setuid,posix_strerror,posix_times,posix_ttyname,posix_uname /g' /usr/local/php/etc/php.ini
sed -i '/#user  nobody;/a\user www www;' /usr/local/nginx/conf/nginx.conf
sed -i 's/index  index.html index.htm;/ index  index.html index.htm index.php; /g' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a }' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a include fastcgi_params;' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a fastcgi_index index.php;' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a fastcgi_pass 127.0.0.1:9000;' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a root html;' /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a location ~ \.php$ {' /usr/local/nginx/conf/nginx.conf
rm -rf /usr/local/nginx/html/*
echo -e "<?php\nphpinfo();\n?>" > /usr/local/nginx/html/index.php
/etc/init.d/nginx restart
service php-fpm  start
#php_end
#php-ext_start
ln -s /usr/local/php/lib/php/extensions /usr/lib64/extensions
#ioncube
cd /usr/local/src
tar zxvf ioncube_loaders_lin_x86-64.tar.gz
mkdir /usr/local/ioncube
\cp -rf ioncube/*  /usr/local/ioncube
sed -i '$a [ionCube Loader] ' /usr/local/php/etc/php.ini
sed -i '$a zend_extension="/usr/local/ioncube/ioncube_loader_lin_5.6.so" ' /usr/local/php/etc/php.ini
#suhosin
cd /usr/local/src
tar zxvf suhosin-suhosin-0.9.36.tar.gz
cd suhosin-suhosin-0.9.36
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config
make && make install
sed -i '$a extension="suhosin.so" ' /usr/local/php/etc/php.ini
#memcache
cd /usr/local/src
tar zxvf memcache-2.2.7.tgz
cd memcache-2.2.7
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config
make && make install
sed -i '$a extension="memcache.so" ' /usr/local/php/etc/php.ini
#re2c
cd /usr/local/src
tar -zxvf re2c-0.13.5.tar.gz
cd re2c-0.13.5
./configure
make && make install
#ImageMagick
cd /usr/local/src
tar zxvf ImageMagick-6.8.9-3.tar.gz
cd ImageMagick-6.8.9-3
./configure --prefix=/usr/local/imagemagick
make && make install
export PKG_CONFIG_PATH=/usr/local/imagemagick/lib/pkgconfig/
#imagick
cd /usr/local/src
tar zxvf imagick-3.1.2.tgz
cd imagick-3.1.2
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config --with-imagick=/usr/local/imagemagick
make && make install
sed -i '$a extension="imagick.so" ' /usr/local/php/etc/php.ini
#MagickWand
cd /usr/local/src
tar zxvf MagickWandForPHP-1.0.9-2.tar.gz
cd MagickWandForPHP-1.0.9
/usr/local/php/bin/phpize
./configure  --with-php-config=/usr/local/php/bin/php-config --with-magickwand=/usr/local/imagemagick
make && make install
sed -i '$a extension="magickwand.so" ' /usr/local/php/etc/php.ini
#phpredis
cd /usr/local/src
tar zxvf phpredis-2.2.6.tar.gz
cd phpredis-2.2.6
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
sed -i '$a extension="redis.so" ' /usr/local/php/etc/php.ini
#mongo
cd /usr/local/src
tar  zxvf mongo-1.5.8.tgz
cd mongo-1.5.8
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install
sed -i '$a extension="mongo.so" ' /usr/local/php/etc/php.ini
service php-fpm restart
#php-ext_end
#vsftpd_start
yum install -y db4* vsftpd
#CentOS 7 vsftpd
yum install -y psmisc net-tools systemd-devel libdb-devel perl-DBI
service vsftpd start
chkconfig vsftpd on
sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_upload_enable=YES/anon_upload_enable=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#anon_mkdir_write_enable=YES/anon_mkdir_write_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#chown_uploads=YES/chown_uploads=NO/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#async_abor_enable=YES/async_abor_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_upload_enable=YES/ascii_upload_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ascii_download_enable=YES/ascii_download_enable=YES/g" '/etc/vsftpd/vsftpd.conf'
sed -i "s/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=Welcome to FTP service./g" '/etc/vsftpd/vsftpd.conf'
echo -e "use_localtime=YES\nlisten_port=21\nchroot_local_user=YES\nidle_session_timeout=300\ndata_connection_timeout=1\nguest_enable=YES\nguest_username=www\nuser_config_dir=/etc/vsftpd/vconf\nvirtual_use_local_privs=YES\npasv_min_port=10045\npasv_max_port=10090\naccept_timeout=5\nconnect_timeout=1" >> /etc/vsftpd/vsftpd.conf
touch /etc/vsftpd/virtusers
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
chmod 600 /etc/vsftpd/virtusers.db
sed -i '1i\auth sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers\naccount sufficient /lib64/security/pam_userdb.so db=/etc/vsftpd/virtusers' /etc/pam.d/vsftpd
mkdir  /etc/vsftpd/vconf
service vsftpd restart
service vsftpd stop
#vsftpd_end
#conf_start
cd /usr/local/src
\cp Conf/index.php  /usr/local/nginx/html/index.php
cp Conf/gd.php  /usr/local/nginx/html/gd.php
cp Conf/server.php  /usr/local/nginx/html/server.php
cp Conf/phpinfo.php  /usr/local/nginx/html/phpinfo.php
cp Conf/vhost.sh /home/vhost.sh
chmod +x /home/vhost.sh
chown www.www /usr/local/nginx/html/ -R
chmod 700 /usr/local/nginx/html/ -R
mv /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak
cp Conf/nginx.conf  /usr/local/nginx/conf/nginx.conf
cp Conf/rewrite.conf  /usr/local/nginx/conf/rewrite.conf
mkdir /usr/local/nginx/conf/vhost
cp Conf/localhost.conf /usr/local/nginx/conf/vhost/localhost.conf
#conf_end
service mysqld restart
service php-fpm restart
service nginx restart