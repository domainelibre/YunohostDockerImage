#!/bin/bash

[ -z $SIMPLE_VERSION ] && SIMPLE_VERSION=3.6
[ -z $FULL_VERSION ] && FULL_VERSION=${SIMPLE_VERSION}.4.6-1

docker tag domainelibre/yunohost3-arm:build domainelibre/yunohost3-arm:$FULL_VERSION
docker tag domainelibre/yunohost3-arm:build domainelibre/yunohost3-arm:$SIMPLE_VERSION
docker tag domainelibre/yunohost3-arm:build domainelibre/yunohost3-arm:latest

#docker push domainelibre/yunohost-arm:$FULL_VERSION
#docker push domainelibre/yunohost-arm:$SIMPLE_VERSION
#docker push domainelibre/yunohost-arm:latest

docker push domainelibre/yunohost3-arm:$FULL_VERSION
docker push domainelibre/yunohost3-arm:$SIMPLE_VERSION
docker push domainelibre/yunohost3-arm:latest

#docker push domainelibre/yunohost:$FULL_VERSION
#docker push domainelibre/yunohost:$SIMPLE_VERSION
#docker push domainelibre/yunohost:latest
