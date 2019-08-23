#!/bin/bash

export SIMPLE_VERSION=3.6
export FULL_VERSION=${SIMPLE_VERSION}.4.6-1
export DOCKER_FILE=Dockerfile_ARMV7

bash specific-home-script_just-build.sh
bash specific-home-script_just-push.sh
