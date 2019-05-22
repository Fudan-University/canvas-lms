#!/usr/bin/env bash

set -e

# 切换到当前目录
cd $(dirname $(readlink -f $0))

# 导入环境变量
set -a
. ./env_file
set +a

docker-compose -f docker-compose.build.yml build

# 创建 canvas-public 数据卷
# 如果已经创建了，会继续维持原有的卷
# 但 docker volume rm 如果卷不存在会报错
# 所以，简单起见，使用两次 create ，保证脚本不出错
docker volume create canvas-public
docker volume rm canvas-public
docker volume create canvas-public
docker run --rm --name copy-volume -v canvas-public:/volume --entrypoint cp sinicize/canvas-app:${CANVAS_VERSION} -r public/. /volume

# 文件存储卷
docker volume create canvas-file
