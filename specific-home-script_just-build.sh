#!/bin/bash

[ -z $SIMPLE_VERSION ] && SIMPLE_VERSION=3.7
[ -z $FULL_VERSION ] && FULL_VERSION=${SIMPLE_VERSION}.1.3-1
[ -z $DOCKER_FILE ] && DOCKER_FILE=Dockerfile_ARMV7

#--no-cache
docker build --no-cache -f $DOCKER_FILE -t domainelibre/yunohost3-arm:build .
[ $? != 0 ] && echo "echec build dockerfile" && exit 1

docker rm -f yunohost
docker run -d -h yunohost.DOMAIN --name=yunohost --privileged -p 4430:443 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  domainelibre/yunohost3-arm:build /bin/systemd
[ $? != 0 ] && echo "echec run yunohost" && exit 1

docker exec yunohost yunohost tools postinstall -d test.fr -p Test1234 --ignore-dyndns
[ $? != 0 ] && echo "echec postinstall yunohost" && exit 1
