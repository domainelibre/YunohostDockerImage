FROM i386/debian:8

ENV INSTALL_TYPE stable
ENV BRANCHE_TYPE master

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y systemd && apt-get clean

ADD preinstall.sh /tmp/preinstall.sh

RUN chmod +x /tmp/preinstall.sh
RUN /tmp/./preinstall.sh && rm /tmp/preinstall.sh && apt-get clean && apt-get autoclean

CMD ["/bin/systemd"]
