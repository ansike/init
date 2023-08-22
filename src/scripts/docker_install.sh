install_docker() {
  echo "开始安装docker"
  sudo apt-get install docker-ce -y
}

sudo apt-get update -y
sudo apt-get upgrade -y
install_docker
