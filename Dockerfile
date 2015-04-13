FROM debian:wheezy
MAINTAINER kload "kload@kload.fr"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

RUN mkdir /etc/yunohost \
 && touch /etc/yunohost/from_script

ADD yunohost.conf /etc/yunohost/yunohost.conf
ADD debconfv2 /tmp/debconfv2

RUN rm /usr/sbin/policy-rc.d \
 && apt-get update --quiet \
 && apt-get install -y --force-yes --no-install-recommends wget apt-utils openssh-server \
 && echo "deb http://repo.yunohost.org/ megusta main" >> /etc/apt/sources.list.d/yunohost.list \
 && wget -O- http://repo.yunohost.org/yunohost.asc -q | apt-key add - -qq \
 && apt-get update --quiet \
 && debconf-set-selections /tmp/debconfv2 \
 && apt-get install -y --force-yes \
 && apt-get -o Dpkg::Options::="--force-confold" install -qq -y --force-yes \
 yunohost yunohost-config yunohost-config-postfix postfix postfix-ldap postfix-policyd-spf-perl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD firstrun /etc/init.d/firstrun
RUN update-rc.d firstrun defaults

EXPOSE 22 25 53/udp 443 465 993 5222 5269 5290
CMD /sbin/init
