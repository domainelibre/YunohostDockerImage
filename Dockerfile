FROM debian:jessie
MAINTAINER ljf "valentin@grimaud.me"

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C
RUN rm -f /usr/sbin/policy-rc.d
RUN apt-get update --quiet

# Allow amavis running even if uname return a bad hostname
ADD 05-node_id /etc/amavis/conf.d/
RUN chown root:root /etc/amavis/conf.d/05-node_id
RUN chown root:root /etc/amavis
RUN chown root:root /etc/amavis/conf.d
RUN apt-get install -y --force-yes --no-install-recommends -o Dpkg::Options::="--force-confold" amavisd-new psmisc

# Yunohost Installation
RUN apt-get install -y --force-yes --no-install-recommends git ca-certificates
RUN git clone https://github.com/julienmalik/install_script /tmp/install_script
RUN cd /tmp/install_script && ./install_yunohostv2 -a || true
RUN killall dovecot || true
RUN apt-get install -y --force-yes  || true
RUN killall dovecot || true
RUN apt-get install -y --force-yes

# Fix dnsmasq fail on postinstall   
RUN echo '' >> /etc/dnsmasq.conf
RUN echo user=root >> /etc/dnsmasq.conf
RUN export TERM=xterm

ADD firstrun /sbin/postinstall
RUN chmod a+x /sbin/postinstall

EXPOSE 22 25 53/udp 80 443 465 993 5222 5269 5290
CMD /sbin/init
