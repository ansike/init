install_node() {
  echo "start to install nodejs"
  if [ -z `which node` ]; then
    sudo apt install nodejs -y
    [ $? -eq 0 ] && echo "install success" || echo "install error"
  else
    echo "nodejs is already installed "
  fi
}

install_node
