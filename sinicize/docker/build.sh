#!/usr/bin/env bash

set -e

# 切换到当前目录
cd $(dirname $(readlink -f $0))

export CANVAS_VERSION='20190105'
docker-compose -f docker-compose.build.yml build
