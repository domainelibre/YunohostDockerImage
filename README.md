## YunoHost Docker image

This repository contains tools to build and run a YunoHost container using Docker.
Image for amd64, i386 and armv7/armhf (ex : run for PC or run for RaspberryPi 2/3/4, not for RaspberryPi A/B).

With this image, you can use YunoHost like a true instance on physical server with more flexibility for system management (quick install, easier upgrade, multiple instances on the same server, can tag/backup/restore state with docker tools ...).

### Pre-requirements 

**The linux docker host must run systemd.**

### Docker images

#### Downloading prebuit image

```
# image amd64
docker pull domainelibre/yunohost
# image i386
docker pull domainelibre/yunohost-i386
# image arm64v8
docker pull cms0/yunohost
# image armv7/armhf
docker pull domainelibre/yunohost-arm
```

### Running image

* Run Yunohost container with basic services (ssh, smtp, imap, dns, http):

```
# run container
docker run -d -h yunohost.DOMAIN --name=yunohost \
 --privileged \
 --restart always \
 -p 2022:22 \
 -p 25:25 \
 -p 80:80 \
 -p 443:443 \
 -p 465:465 \
 -p 587:587 \
 -p 993:993 \
 -v <backup path>:/home/yunohost.backup \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 <image name, ex : domainelibre/yunohost>
```

* This is a complete example, with more services (ssh, smtp, dns, http, samba, XMPP), mapping local disks, inner docker service ... :

```
# run container
docker run -d -h yunohost.DOMAIN --name=yunohost \
 --privileged \
 --restart always \
 -p 2022:22 \
 -p 25:25 \
 -p 53:53/udp \
 -p 80:80 \
 -p 137:137 \
 -p 138:138 \
 -p 139:139 \
 -p 443:443 \
 -p 445:445 \
 -p 465:465 \
 -p 587:587 \
 -p 993:993 \
 -p 5222:5222 \
 -p 5269:5269 \
 -p 49200:49200 \
 -v /media/mydisk/backup:/home/yunohost.backup \
 -v /media:/media \
 -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
 -v /var/run/docker.sock:/var/run/docker.sock \
 domainelibre/yunohost /bin/systemd
```

* Or from `docker-compose`:
```bash
docker-compose pull
docker-compose up -d
```

* This is a other example, specially for Docker for Windows :)

```
# run container
docker run -d -h yunohost.DOMAIN --name=yunohost \
 --privileged \
 --restart always \
 -p 80:80 \
 -p 22:22 \
 -p 443:443 \
 -v C:/data:/media \
 domainelibre/yunohost
```

### First installing

#### Enter in running container

```
docker exec -it yunohost bash
```

### Post-installation

* simply do ...

```
yunohost tools postinstall
```

* ... or can pass arguments 

```
yunohost tools postinstall -d test.local -p secret
```

#### Install HTTPS certificate

```
yunohost domain cert-install
```

### Backup / Restore

```
# create backup
yunohost backup create
```

```
# list backup
cd /home/yunohost.backup/archives/
ls -t *.tar.gz
```

```
# restore backup
yunohost backup restore <date backup, ex : 20170430-174149>
```

### Migrate to a new image version

**You can classically upgrade your Yunohost instance directly in the container, but for a major upgrade you can follow theses lines :**

* On your current Yunohost container, create a backup

```
yunohost backup create
```

* Stop your current Yunohost container

```
docker stop yunohost
```

* Create a new Yunohost container with new image version

```
# see Running image
docker run -d -h yunohost.DOMAIN --name=yunohost2 \
 ...
 ...
 ...
```

* On your new Yunohost container, restore backup

```
docker exec -it yunohost2 bash
yunohost backup restore <date backup, ex : 20170430-174149>
```

* If restore is ok, you can remove previous container

```
docker rm yunohost
```

### Building image witgh docker-compose

```
# clone yunohost install script
git clone https://github.com/christiansteier/YunohostDockerImage
cd YunohostDockerImage

# docker build
docker-compose -f docker-compose.<suffix docker file>.yml build
```

---

