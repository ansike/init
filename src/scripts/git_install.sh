install_git() {
  echo "开始安装git"
  sudo apt install git -y

  echo "set custom git alias"
  git config --global alias.aa add
  git config --global alias.br branch
  git config --global alias.ck checkout
  git config --global alias.cm "commit -m"
}

sudo apt-get update -y
sudo apt-get upgrade -y
install_git
