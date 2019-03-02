#!/usr/bin/env bash

set -e

# 切换到当前目录
cd $(dirname $(readlink -f $0))

# 导入环境变量
set -a
. ./env_file
set +a

docker-compose -f docker-compose.build.yml build
