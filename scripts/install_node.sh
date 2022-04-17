installNode() {
  NODE_VERSION=16.0.0
  NODE_NAME="node.$NODE_VERSION"
  NODE_TAR_NAME="$NODE_NAME.tar.gz"
  wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.gz" -O $NODE_TAR_NAME
  if [ $? != 0 ]; then
    echo "node 下载失败"
    return 2
  fi
  tar -xvf $NODE_TAR_NAME
  # 删除原有路径
  rm -rf /usr/local/opt/$NODE_NAME
  mv $NODE_NAME /usr/local/opt/$NODE_NAME

  # 设置path
  echo "设置node环境path"
  cp /etc/profile /etc/profile.bak
  cat "export PATH=$PATH:/usr/local/opt/$NODE_NAME/bin" >>/etc/profile
  echo "当前node版本为： $(node -v)"
  # echo "当前npm版本为： $(node -v)"
}

installNode
