# YunoHost Dockerfile

This repository contains the Dockerfile recipe to build a YunoHost container using Docker.

This package is only for testing/developement purpose and yunohost firewall might not working correctly. 

If you need to test apps or firewall settings prefer a stronger virtualization. 

**Tested on Docker 1.7.1**

## Downloading prebuit image

```
docker pull yunohost/full
```

## Building

```
docker build -t yunohost/full github.com/YunoHost/Dockerfile
```

## Running

Run your container (don't forget to replace DOMAIN):

```
docker run -h yunohost.DOMAIN -v $(pwd):/yunohost -d yunohost/full /sbin/init
```


If you want to run the container and forward all the interesting ports to the host:
```
docker run -h yunohost.DOMAIN -v $(pwd):/yunohost -d \
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

Enter in your container by replacing XXXX by the 4 first character of the container id

```
docker exec -t -i XXXX /bin/bash
```

And then run the special postinstall for docker
```
postinstall
```

---

**More information on [yunohost.org/docker](https://yunohost.org/docker)**
