#!/bin/bash

SIMPLE_VERSION=2.7
FULL_VERSION=${SIMPLE_VERSION}.10-1

docker build --no-cache -f Dockerfile_ARMV7 -t domainelibre/yunohost-arm:build .
[ $? != 0 ] && echo "echec build dockerfile" && exit 1

docker rm -f yunohost
docker run -d -h yunohost.DOMAIN --name=yunohost --privileged -p 4430:443 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  domainelibre/yunohost-arm:build /bin/systemd
[ $? != 0 ] && echo "echec run yunohost" && exit 1

docker exec yunohost yunohost tools postinstall -d test.fr -p test --ignore-dyndns
[ $? != 0 ] && echo "echec postinstall yunohost" && exit 1

docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:$FULL_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:$SIMPLE_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:latest
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost2-arm:$FULL_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost2-arm:$SIMPLE_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost2-arm:latest

docker push domainelibre/yunohost-arm:$FULL_VERSION
docker push domainelibre/yunohost-arm:$SIMPLE_VERSION
docker push domainelibre/yunohost-arm:latest
docker push domainelibre/yunohost2-arm:$FULL_VERSION
docker push domainelibre/yunohost2-arm:$SIMPLE_VERSION
docker push domainelibre/yunohost2-arm:latest

docker pull domainelibre/yunohost2:$FULL_VERSION
docker tag domainelibre/yunohost2:$FULL_VERSION domainelibre/yunohost:$FULL_VERSION
docker tag domainelibre/yunohost2:$FULL_VERSION domainelibre/yunohost:$SIMPLE_VERSION
docker tag domainelibre/yunohost2:$FULL_VERSION domainelibre/yunohost:latest
docker push domainelibre/yunohost:$FULL_VERSION
docker push domainelibre/yunohost:$SIMPLE_VERSION
docker push domainelibre/yunohost:latest

