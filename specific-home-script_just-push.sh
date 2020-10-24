#!/bin/bash

[ -z $SIMPLE_VERSION ] && SIMPLE_VERSION=4.0
[ -z $FULL_VERSION ] && FULL_VERSION=${SIMPLE_VERSION}.8-2

docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:$FULL_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:$SIMPLE_VERSION
docker tag domainelibre/yunohost-arm:build domainelibre/yunohost-arm:latest

docker push domainelibre/yunohost-arm:$FULL_VERSION
docker push domainelibre/yunohost-arm:$SIMPLE_VERSION
docker push domainelibre/yunohost-arm:latest
