#!/bin/bash

export SIMPLE_VERSION=4.0
export FULL_VERSION=${SIMPLE_VERSION}.8.1-1
export DOCKER_FILE=Dockerfile_ARMV7

bash specific-home-script_just-build.sh
bash specific-home-script_just-push.sh
