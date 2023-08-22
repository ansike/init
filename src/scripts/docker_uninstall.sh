uninstall_docker() {
  echo "开始卸载docker"
  sudo apt-get purge docker docker-ce docker-buildx-plugin docker-ce-cli docker-ce-rootless-extras docker-compose-plugin wmdocker -y

  [ -z `which docker` ] && echo "卸载成功" || echo “卸载失败”
}

uninstall_docker
