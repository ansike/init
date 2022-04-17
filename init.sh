#!/bin/bash
echo "开始安装软件"

# 安装node
echo "开始安装 node"

isRoot() {
  [[ $EUID != 0 ]] && echo "请切换到root用户，执行安装脚本" && exit 1
}


# isRoot

# 安装node
sh ./scripts/install_node.sh

# 安装git
sh ./scripts/install_git.sh