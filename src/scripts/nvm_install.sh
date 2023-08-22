install_nvm() {
  echo "start to install nvm"
  if [ ! command -v "$1" &>/dev/null ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    [ $? -eq 0 ] && {
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
      echo "install success"
    } || echo "install error"
  else
    echo "nvm is already installed "
  fi
}

install_nvm
