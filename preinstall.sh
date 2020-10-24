#!/bin/bash

DIRORI=$(dirname $0)
cd $DIRORI

# install type
INSTALL_TYPE=stable
[ "$1" != "" ] && INSTALL_TYPE=$1

# branche_type
BRANCHE_TYPE=buster
[ "$2" != "" ] && BRANCHE_TYPE=$2

# install requirements
# deprecated : --force-yes
apt-get update --quiet
apt-get install -y --no-install-recommends wget apt-utils ssh openssl ca-certificates openssh-server nano vim cron git

# debug docker context for resolvconf
# deprecated : --force-yes
apt-get install -y --no-install-recommends resolvconf 2>/dev/null || \
 echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

# get yunohost git repo
git clone -b $BRANCHE_TYPE https://github.com/YunoHost/install_script /tmp/install_script
git -C /tmp/install_script checkout $BRANCHE_TYPE

# hack YunoHost install_script for bypass systemd check
sed -i "s@/run/systemd/system@/run@g" /tmp/install_script/install_yunohost

# debug systemctl issues for docker, add proxy
mv /bin/systemctl /bin/systemctl.bin
echo -e "#"'!'"/bin/sh\n/bin/./systemctl.bin\nexit 0\n" > /bin/systemctl
chmod +x /bin/systemctl

# force ulimit for slapd now
ulimit -n 1024

# do yunohost installation
cd /tmp/install_script
./install_yunohost -f -a -d $INSTALL_TYPE
[ "$?" != "0" ] && echo "error while yunohost installation" && exit 1

# hack iptables for yunohost in docker
mv /usr/sbin/iptables /usr/sbin/iptables.ori
echo -e "#"'!'"/bin/sh\necho \"fake iptables for yunohost inside docker, unusable. For return non failure unix code 0. Bye !\"\nexit 0\n" > /usr/sbin/iptables
chmod +x /usr/sbin/iptables

# remove proxy for systemctl
rm -f /bin/systemctl
mv /bin/systemctl.bin /bin/systemctl

# force ulimit for slapd in starting script
sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd

# patchs for yunohost
adduser admin
systemctl enable nginx
systemctl enable yunohost-api
systemctl enable php7.3-fpm
systemctl enable fail2ban
[ ! -f /etc/fail2ban/filter.d/sshd-ddos.conf ] \
	&& echo -e "[Definition]\n" > /etc/fail2ban/filter.d/sshd-ddos.conf
[ ! -f /etc/fail2ban/filter.d/postfix-sasl.conf ] \
        && echo -e "[Definition]\n" > /etc/fail2ban/filter.d/postfix-sasl.conf
touch /var/log/mail.log
#systemctl enable dovecot
#systemctl enable postfix
#systemctl enable rspamd
#systemctl enable avahi-daemon
#systemctl enable dnsmasq
#systemctl enable redis-server

# cleaning
apt-get clean

