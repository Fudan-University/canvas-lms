#!/usr/bin/env bash

set -e

# 切换到当前目录
cd $(dirname $(readlink -f $0))

# 导入环境变量
set -a
. ./env_file
set +a

# 默认单机模式
mode="${1:-solo}"

case $mode in
  solo)
    docker-compose -f docker-compose.solo.yml up -d
    ;;
  swarm)
    docker stack deploy --compose-file docker-compose.yml canvas
    ;;
  *)
    echo "Unknown mode $mode"
    ;;
esac

