#!/usr/bin/env bash

set -e
GITHUB_PREFIX_HTTPS="https://github.com/"
GITHUB_PREFIX_GIT="git://github.com/"
#GITHUB_PREFIX_CODELOAD="https://codeload.github.com"
GITHUB_MIRROR_PREFIX="https://source.fudan.edu.cn/gitlab/canvas/mirrors/"
YARNPKG_PREFIX="https://registry.yarnpkg.com/"
YARNPKG_MIRROR_PREFIX="https://npmreg.proxy.ustclug.org/"

# 切换到当前目录
echo "$(dirname $(readlink -f $0))/.."
cd $(dirname $(readlink -f $0))/..

echo "重定向 Gemfile的GitHub库"
echo "  GitHub镜像: ${GITHUB_PREFIX_HTTPS} -> ${GITHUB_MIRROR_PREFIX}"
sed -i "s,${GITHUB_PREFIX_HTTPS},${GITHUB_MIRROR_PREFIX},g" Gemfile.d/_before.rb

echo "处理 package.json:"
echo "  GitHub镜像: ${GITHUB_PREFIX_HTTPS} -> ${GITHUB_MIRROR_PREFIX}"
sed -i "s,${GITHUB_PREFIX_HTTPS},${GITHUB_MIRROR_PREFIX},g" package.json

echo "处理所有 yarn.lock:"
echo "  GitHub镜像: ${GITHUB_PREFIX_HTTPS} -> ${GITHUB_MIRROR_PREFIX}"
echo "  yarnpkg镜像: ${YARNPKG_PREFIX} -> ${YARNPKG_MIRROR_PREFIX}"
find . -name yarn.lock -exec sed -i "s,${GITHUB_PREFIX_HTTPS},${GITHUB_MIRROR_PREFIX},g;s,${GITHUB_PREFIX_GIT},${GITHUB_MIRROR_PREFIX},g;s,${YARNPKG_PREFIX},${YARNPKG_MIRROR_PREFIX},g" {} +
