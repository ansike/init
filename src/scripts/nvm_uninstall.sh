install_nvm() {
  echo "start to install nvm"
  if [ ! command -v "$1" ] &>/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    [ $? -eq 0 ] && {

      nvm_config='
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
'

      if [ -n "$BASH_VERSION" ]; then
        # User is using Bash
        echo "$nvm_config" >>~/.bashrc
        echo "Added nvm configuration to ~/.bashrc"
      elif [ -n "$ZSH_VERSION" ]; then
        # User is using Zsh
        echo "$nvm_config" >>~/.zshrc
        echo "Added nvm configuration to ~/.zshrc"
      else
        echo "Unsupported shell. Unable to configure nvm."
      fi
      
      echo "install success"
    } || echo "install error"
  else
    echo "nvm is already installed "
  fi
}

install_nvm
