installGit() {
  #
  echo "开始安装git"
  # Git_VERSION=16.0.0
  # Git_NAME="Git.$Git_VERSION"
  # Git_TAR_NAME="$Git_NAME.tar.gz"
  # wget "https://Gitjs.org/dist/v$Git_VERSION/Git-v$Git_VERSION.tar.gz" -O $Git_TAR_NAME
  # if [ $? != 0 ]; then
  #   echo "Git 下载失败"
  #   return 2
  # fi
  # tar -xvf $Git_TAR_NAME
  # # 删除原有路径
  # rm -rf /usr/local/opt/$Git_NAME
  # mv $Git_NAME /usr/local/opt/$Git_NAME

  # # 设置path
  # echo "设置Git环境path"
  # cp /etc/profile /etc/profile.bak
  # cat "export PATH=$PATH:/usr/local/opt/$Git_NAME/bin" >>/etc/profile
  # echo "当前Git版本为： $(Git -v)"
  # echo "当前npm版本为： $(Git -v)"
}

installGit
