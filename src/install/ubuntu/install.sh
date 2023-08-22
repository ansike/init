#!/bin/bash

# set -e

# 需要按照自己实际的代理走
export http_proxy=http://localhost:7890
export https_proxy=http://localhost:7890

# 检查软件是否已经安装
check_installed() {
    # echo "检查命令是否存在"$1
    command -v "$1" &>/dev/null
}

# 输出日志信息
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

format_print() {
    log "\033[32m✓ $*\033[0m"
}

# 增加配置到rc文件中
add_config_to_rc() {
    local config="$1"
    local shell_name="$SHELL"

    if [ -n "$shell_name" ]; then
        if [[ "$shell_name" == *"bash"* ]]; then
            local shell_rc="$HOME/.bashrc"
        elif [[ "$shell_name" == *"zsh"* ]]; then
            local shell_rc="$HOME/.zshrc"
        else
            log "Unsupported shell: $shell_name"
            return
        fi
        if [ -n "$shell_rc" ] && [ -f "$shell_rc" ]; then
            # 判断已经设置上
            if ! cat $shell_rc | grep -F "$config"; then
                log "$config" >>"$shell_rc"
                log "Added configuration to $shell_rc"
            else
                log "Configuration already exists in $shell_rc"
            fi
        else
            log "Shell configuration file not found: $shell_rc"
        fi
    else
        log "Unable to determine user's shell."
    fi
}

##################################################### 安装&配置 ###########################################################

log "开始设置 bash alias"
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias pro='cd ～/pro'

log "检查是否存在 ~/.ssh 目录"
# 检查 SSH 目录是否存在
if [ ! -d "$HOME/.ssh" ]; then
    log "创建 SSH 目录..."
    mkdir "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
else
    log "已存在 SSH 目录"
fi

# 生成 SSH 公私钥
generate_ssh_keys() {
    ssh_dir="$HOME/.ssh"
    private_key_file="$ssh_dir/id_rsa"
    public_key_file="$ssh_dir/id_rsa.pub"

    if [ -f "$private_key_file" ] || [ -f "$public_key_file" ]; then
        log "SSH 公私钥已存在。"
    else
        log "正在生成 SSH 公私钥..."
        ssh-keygen -t rsa -b 4096 -f "$private_key_file" -N "" -q
        log "SSH 公私钥已生成。"
    fi

    log "SSH 公钥内容："
    cat "$public_key_file"
}

install_git() {
    log "开始安装git"
    if ! check_installed "git"; then
        sudo apt install git -y
    else
        log "git already installed"
    fi

    log "set custom git alias"
    git config --global alias.aa add
    git config --global alias.br branch
    git config --global alias.ck checkout
    git config --global alias.cm "commit -m"
}

install_docker() {
    log "开始安装docker"
    if ! check_installed "docker"; then
        sudo apt install docker-ce -y
    else
        log "git already installed"
    fi
}

install_node() {
    log "start to install nodejs"
    if [ -z $(which node) ]; then
        sudo apt install nodejs -y
        [ $? -eq 0 ] && log "install success" || log "install error"
    else
        log "nodejs is already installed "
    fi
}

install_npm() {
    log "start to install npm"
    if [ -z $(which npm) ]; then
        sudo apt install npm -y
        [ $? -eq 0 ] && log "install success" || log "install error"
    else
        log "npm is already installed "
    fi
}

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

generate_ssh_keys

install_docker

install_git

install_node

install_npm

install_nvm

# 完成提示
format_print "初始化完成！"

# 删除代理
export http_proxy=
export https_proxy=
