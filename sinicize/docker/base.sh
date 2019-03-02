#!/usr/bin/env bash

set -e

# 切换到当前目录
cd $(dirname $(readlink -f $0))

export CANVAS_VERSION='20190105'

# RubyGems镜像
# 阿里云
export RUBYGEMS_MIRROR='https://mirrors.aliyun.com/rubygems/'
# 清华
# export RUBYGEMS_MIRROR='https://mirrors.tuna.tsinghua.edu.cn/rubygems'

docker-compose -f docker-compose.base.yml build
