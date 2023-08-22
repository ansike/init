install_npm() {
  echo "start to install npm"
  if [ -z $(which npm) ]; then
    sudo apt install npm -y
    [ $? -eq 0 ] && echo "install success" || echo "install error"
  else
    echo "npm is already installed "
  fi
}

install_npm
