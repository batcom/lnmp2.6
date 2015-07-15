#!/bin/sh
echo -e "Please enter your domain name:"
read name
echo -n "Are you sure (Y/N)?"
read ANS
case $ANS in
y|Y|yes|Yes)
mkdir -p /data/wwwroot/$name/web
chown www.www -R /data/wwwroot/$name/web
mkdir -p /data/php-cgi/tmp/$name
chmod 777 -R /data/php-cgi/tmp/$name
cp /usr/local/nginx/conf/vhost/localhost.conf  /usr/local/nginx/conf/vhost/$name.conf
sed -i 's/localhost/'$name'/g' /usr/local/nginx/conf/vhost/$name.conf
sed -i 's/\/usr\/local\/nginx\/html/\/data\/wwwroot\/'$name'\/web/g' /usr/local/nginx/conf/vhost/$name.conf
echo -e "[HOST=$name]\n[PATH=/data/wwwroot/$name/web]\nupload_tmp_dir=/data/php-cgi/tmp/$name\nopen_basedir=/data/wwwroot/$name/web:/data/php-cgi/tmp/$name/" >> /etc/php.ini
service nginx reload
service php-fpm stop
service php-fpm start
echo -e "Congratulations Virtual host added successfully!"
echo -e "Please delete this page!</br>" >> /data/wwwroot/$name/web/index.php
echo -e "Congratulations, virtual host a successful beginning!</br>" >> /data/wwwroot/$name/web/index.php
echo -e "This page is for the file name:/data/wwwroot/$name/web/index.php</br>" >> /data/wwwroot/$name/web/index.php
echo -e "Your domain name for:$name</br>" >> /data/wwwroot/$name/web/index.php
;;
n|N|no|No)
       #exit 0
sh vhost.sh
;;
esac
echo -n "Whether to open ftp service?(Y/N)"
read ANS
case $ANS in
y|Y|yes|Yes)
echo -e "Please enter you password for ftp server:"
read ospassword
echo -e "$name\n$ospassword" >> /etc/vsftpd/virtusers
db_load -T -t hash -f /etc/vsftpd/virtusers /etc/vsftpd/virtusers.db
chmod 600 /etc/vsftpd/virtusers.db
echo -e "local_root=/data/wwwroot/$name\nwrite_enable=YES\nanon_world_readable_only=NO\nanon_upload_enable=YES\nanon_mkdir_write_enable=YES\nanon_other_write_enable=YES" >> /etc/vsftpd/vconf/$name
echo -e "Your FTP username:$name</br>" >> /data/wwwroot/$name/web/index.php
echo -e "FTP login password:$ospassword</br>" >> /data/wwwroot/$name/web/index.php
echo -e "FTP port number:21</br>" >> /data/wwwroot/$name/web/index.php
service vsftpd start
service vsftpd restart
;;
n|N|no|No)
       #exit 0
echo ""
;;
esac