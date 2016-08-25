# YunoHost 2.4 Docker image

This repository contains tools to build a YunoHost 2.4 container using Docker.
Image for amd64 and armv7/armhf (ex : run for PC or run for RaspberryPi 2, not for RaspberryPi A/B).

## Pre-requirements 

**The linux docker host must run systemd.**
**Tested on Docker 1.7.1**

## Downloading prebuit image

```
# image amd64
docker pull domainelibre/yunohost
# image armv7/armhr
docker pull domainelibre/yunohost-arm
```

## Running AMD64 image

YunoHost is using many services, therefore many ports are to be opened:

```
# run container
docker run -d -h yunohost.DOMAIN --name=yunohost \
 --privileged \
 -p 25:25 \
 -p 53:53/udp \
 -p 80:80 \
 -p 443:443 \
 -p 465:465 \
 -p 993:993 \
 -p 5222:5222 \
 -p 5269:5269 \
 -p 5290:5290 \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 domainelibre/yunohost /bin/systemd

# start container if already created
docker start yunohost
```

You may want to open the SSH port (22) as well.

## Running ARM image

YunoHost is using many services, therefore many ports are to be opened:

```
# run container
docker run -d -h yunohost.DOMAIN --name=yunohost \
 --privileged \
 -p 25:25 \
 -p 53:53/udp \
 -p 80:80 \
 -p 443:443 \
 -p 465:465 \
 -p 993:993 \
 -p 5222:5222 \
 -p 5269:5269 \
 -p 5290:5290 \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 domainelibre/yunohost-arm /bin/systemd

# start container if already created
docker start yunohost
```

You may want to open the SSH port (22) as well.

## Post-installing

### Enter in running image

```
docker exec -it yunohost bash
yunohost tools postinstall
```

### (OR) Go on post-install yunohost local web page

Get your container's IP address (replace the CONTAINER_ID):

```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <CONTAINER_ID>
```

Then go to https://CONTAINER_IP with your web browser.

## Building AMD64 image

```
# clone yunohost install script
git clone https://github.com/aymhce/YunohostDockerImage

# rm if already created
docker rm -f yunohost-build

# run debian image
docker run -d -h yunohost.DOMAIN -v $(pwd):/yunohost --name=yunohost-build \
 --privileged \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 debian /bin/systemd

# enter in running image
docker exec -it yunohost-build bash

# install yunohost
cd /yunohost/YunohostDockerImage/
chmod +x preinstall.sh
./preinstall.sh
apt-get clean
apt-get autoclean
history -c
exit

# commit image on local
docker commit yunohost-build domainelibre/yunohost:build
```

## Building ARM image

```
# clone yunohost install script
git clone https://github.com/aymhce/YunohostDockerImage

# rm if already created
docker rm -f yunohost-build

# run debian image
docker run -d -h yunohost.DOMAIN -v $(pwd):/yunohost --name=yunohost-build \
 --privileged \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 armhf/debian /bin/systemd

# enter in running image
docker exec -it yunohost-build bash

# install yunohost
cd /yunohost/YunohostDockerImage/
chmod +x preinstall.sh
./preinstall.sh
apt-get clean
apt-get autoclean
history -c
exit

# commit image on local
docker commit yunohost-build domainelibre/yunohost-arm:build
```

---

