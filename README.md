# YunoHost Dockerfile

This reposiroty contains the Dockerfile recipe to build a YunoHost container using Docker.

**Tested on Docker 1.5.0**

## Downloading prebuit image

```
docker pull yunohost/full
```

## Building

```
docker build -t yunohost/full github.com/YunoHost/Dockerfile
```

## Running

YunoHost is using many services, therefore many ports are to be opened:

```
docker run -d \
 -p 25:25 \
 -p 53:53/udp \
 -p 80:80 \
 -p 443:443 \
 -p 465:465 \
 -p 993:993 \
 -p 5222:5222 \
 -p 5269:5269 \
 -p 5290:5290 \
 yunohost/full \
 /sbin/init
```

You may want to open the SSH port (22) as well.


## Post-installing

Get your container's IP address (replace the CONTAINER_ID):

```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <CONTAINER_ID>
```

Then go to https://container.ip with your web browser.


---

**More information on [yunohost.org/docker](https://yunohost.org/docker)**
