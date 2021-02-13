FROM debian:10.6

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y systemd && apt-get clean

ADD preinstall.sh /tmp/preinstall.sh

RUN chmod +x /tmp/preinstall.sh
RUN /tmp/./preinstall.sh && rm /tmp/preinstall.sh && apt-get clean && apt-get autoclean

ADD hack_scripts/hostfiles-hack.sh /usr/local/bin/
ADD hack_scripts/hostfiles-hack.service /etc/systemd/system/
RUN chmod 664 /etc/systemd/system/hostfiles-hack.service && \
 chmod 744 /usr/local/bin/hostfiles-hack.sh && \
 systemctl enable hostfiles-hack.service

CMD ["/bin/systemd"]
