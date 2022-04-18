#!/bin/bash
echo "开始安装软件"

# 安装node
echo "开始安装 node"

isRoot() {
  [ $EUID -ne 0 ] && echo "请切换到root用户，执行安装脚本" && exit 1
}


# isRoot
isRoot

# 安装node
# sh ./scripts/install_node.sh

installNode() {
  NODE_VERSION=16.0.0
  NODE_NAME="node.$NODE_VERSION"
  NODE_TAR_NAME="$NODE_NAME.tar.xz"
  wget "https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.xz" -O $NODE_TAR_NAME
  if [ $? != 0 ]; then
    echo "node 下载失败"
    return 2
  fi
  tar -xvf $NODE_TAR_NAME
  # 删除原有路径
  rm -rf /usr/local/opt/$NODE_NAME
  mkdir -p  /usr/local/opt/
  mv $NODE_NAME /usr/local/opt/$NODE_NAME

  # 全局环境使用node相关命令有两种方式
  # 1. 设置path
  echo "设置node环境path"
  cp ~/.profile ~/.profile.bak
  cat "export PATH=$PATH:/usr/local/opt/$NODE_NAME/bin" >> ~/.profile
  source ~/.profile

  # 2. 设置软链指向 /usr/local/opt/$NODE_NAME/bin/ 目录
  # ln -s /usr/local/opt/$NODE_NAME/bin/node /usr/bin/node
  # ln -s /usr/local/opt/$NODE_NAME/bin/npm /usr/bin/npm
  # ln -s /usr/local/opt/$NODE_NAME/bin/npx /usr/bin/npx

  echo "当前node版本为： $(node -v)"
  # echo "当前npm版本为： $(node -v)"
}

installNode



# 安装git
# sh ./scripts/install_git.sh
installGit() {
  #
  echo "开始安装git"
  git config --global alias.st status
  git config --global alias.aa "add ."
  git config --global alias.br branch
  git config --global alias.ck checkout
  git config --global alias.cm "commit -m"
}

installGit