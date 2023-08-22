uninstall_git() {
  echo "开始清理git"
  sudo apt-get remove git -y
  [ -z `which git` ] && echo "卸载成功" || echo “卸载失败”
}

uninstall_git
