#!/bin/bash

DIRORI=$(dirname $0)
cd $DIRORI

# install requirements
apt update --quiet
apt upgrade -y --force-yes
apt install -y --force-yes --no-install-recommends wget apt-utils ssh openssl ca-certificates openssh-server nano vim cron git htop dialog sudo-ldap curl unzip ssl-cert locales tzdata

# install metronome dependencies
apt install -y --force-yes libssl-dev libidn11-dev lua5.1 liblua5.1-0-dev lua-bitop-dev lua-expat-dev lua-event-dev lua-posix-dev lua-sec-dev lua-socket-dev lua-filesystem-dev

# compile and install metronome for arm
apt install -y --force-yes gcc fakeroot build-essential quilt dh-autoreconf
wget https://github.com/YunoHost/metronome/archive/debian/3.7.9+33b7572-1.zip
unzip 3.7.9+33b7572-1.zip
rm -f 3.7.9+33b7572-1.zip
cd metronome-debian-3.7.9-33b7572-1
dpkg-buildpackage -rfakeroot -uc -b -d
cd ..
dpkg -i metronome_3.7.9+33b7572-1_armhf.deb
apt-mark hold metronome
rm -rf metronome_3.7.9*
apt remove -y --force-yes gcc fakeroot build-essential quilt dh-autoreconf

# get yunohost git repo
git clone https://github.com/YunoHost/install_script /tmp/install_script

# hack YunoHost install_script for bypass systemd check
sed -i "s@/run/systemd/system@/run@g" /tmp/install_script/install_yunohost

# do yunohost installation
cd /tmp/install_script
./install_yunohost -a -d stable
if [ "$?" != "0" ]; then
 echo "error while yunohost installation. Retry with /etc/init.d/slapd customize with ulimit"
 sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd
 systemctl daemon-reload
 ./install_yunohost -a -d stable
 [ "$?" != "0" ] && echo "error while yunohost installation." && exit 1
else
 # force ulimit for slapd
 sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd
 systemctl daemon-reload
fi

apt-get clean
apt-get autoclean
history -c
exit 0
