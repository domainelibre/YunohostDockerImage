# YunoHost 2.X Docker image

This repository contains tools to build a YunoHost 2.X container using Docker.
Image for amd64 and armv7/armhf (ex : run for PC or run for RaspberryPi 2, not for RaspberryPi A/B).

## Pre-requirements 

**The linux docker host must run systemd.**

**Tested on Docker 17.05**

## Downloading prebuit image

```
# image amd64
docker pull domainelibre/yunohost2
# image armv7/armhf
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
 -p 587:587 \
 -p 993:993 \
 -p 5222:5222 \
 -p 5269:5269 \
 -p 5290:5290 \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 domainelibre/yunohost2 /bin/systemd

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
 -p 587:587 \
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

### Enter in running container

```
docker exec -it yunohost bash
yunohost tools postinstall
```

### Install HTTPS certificate

```
yunohost domain cert-install
```

## Building AMD64 image

```
# clone yunohost install script
git clone https://github.com/aymhce/YunohostDockerImage
cd YunohostDockerImage

# docker build
docker build -f dockerfiles/amd64/Dockerfile_AMD64 -t domainelibre/yunohost:build .
```

## Building ARM image

```
# clone yunohost install script
git clone https://github.com/aymhce/YunohostDockerImage
cd YunohostDockerImage

# docker build
docker build -f dockerfiles/armv7/Dockerfile_ARMV7 -t domainelibre/yunohost-arm:build .
```

---

