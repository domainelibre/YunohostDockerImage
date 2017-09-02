#!/bin/bash

DIRORI=$(dirname $0)
cd $DIRORI

# install type
INSTALL_TYPE=stable
[ "$1" != "" ] && INSTALL_TYPE=$1

# branche_type
BRANCHE_TYPE=master
[ "$2" != "" ] && BRANCHE_TYPE=$2

# install requirements
apt-get update --quiet
apt-get install -y --force-yes --no-install-recommends wget apt-utils ssh openssl ca-certificates openssh-server nano vim cron git

# debug docker context for resolvconf
apt-get install -y --force-yes --no-install-recommends resolvconf 2>/dev/null || \
 echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

# get yunohost git repo
git clone -b $BRANCHE_TYPE https://github.com/YunoHost/install_script /tmp/install_script
git -C /tmp/install_script checkout $BRANCHE_TYPE

# hack YunoHost install_script for bypass systemd check
sed -i "s@/run/systemd/system@/run@g" /tmp/install_script/install_yunohost

# do yunohost installation
cd /tmp/install_script
./install_yunohost -a -d $INSTALL_TYPE
[ "$?" != "0" ] && cat /var/log/yunohost-installation.log && echo "error while yunohost installation" && exit 1

# force ulimit for slapd
sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd

# cleaning
apt-get clean
