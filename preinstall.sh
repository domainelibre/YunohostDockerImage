#!/bin/bash

DIRORI=$(dirname $0)
cd $DIRORI

# install requirements
apt-get update --quiet
apt-get install -y --force-yes --no-install-recommends wget apt-utils ssh openssl ca-certificates openssh-server nano vim cron git

# get yunohost git repo
git clone https://github.com/YunoHost/install_script /tmp/install_script

# hack YunoHost install_script for bypass systemd check
sed -i "s@/run/systemd/system@/run@g" /tmp/install_script/install_yunohost

# do yunohost installation
cd /tmp/install_script
./install_yunohost -a -d stable
[ "$?" != "0" ] && echo "error while yunohost installation" && exit 1

# force ulimit for slapd
sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd

apt-get clean
