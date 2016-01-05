# YunoHost Dockerfile

This repository contains the Dockerfile recipe to build a YunoHost container using Docker.

This package is only for testing/developement purpose and yunohost firewall might not work correctly. 

If you need to test apps or firewall settings prefer a stronger virtualization. 

**Tested on Docker 1.7.1**

## Caution

Don't run this dockerfile with --privileged, it could break your host system.


## Downloading prebuilt image

```
docker pull zamentur/yunohost-stable8
```

## Building

```
docker build -t zamentur/yunohost-stable8 github.com/YunoHost/Dockerfile
```

## Running

Run your container (don't forget to replace DOMAIN):

```
docker run -h yunohost.DOMAIN -v $(pwd):/yunohost -d zamentur/yunohost-stable8 /sbin/init
```

You may want to open the SSH port (22) as well.


## Post-installing

Enter your container by replacing XXXX by the 4 first characters of the container id

```
docker exec -t -i XXXX /bin/bash
```

And then run the special postinstall for docker
```
postinstall
```

## Login
By default these passwords are set:
root: yunohost
admin: yunohost

---

**More information on [yunohost.org/docker](https://yunohost.org/docker)**
