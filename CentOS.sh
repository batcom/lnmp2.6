#!/bin/sh
#auto_start
system=`getconf LONG_BIT`
if [ $system = "32" ] ; then
sh Script/CentOS_5_6_32.sh  2> /root/web-install.log
elif [ $system = "64" ] ; then
sh Script/CentOS_5_6_7_64.sh  2> /root/web-install.log
else
echo "This operating system is not supported"
fi
#auto_end