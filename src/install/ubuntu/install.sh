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

check_version() {
    echo "\033[32m✓ $*\033[0m"
}

##################################################### 安装&配置 ###########################################################

echo "开始设置 bash alias"
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias pro='cd ～/pro'

# 检查 SSH 目录是否存在
if [ ! -d "$HOME/.ssh" ]; then
    log "创建 SSH 目录..."
    mkdir "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
fi

# 生成 SSH 公私钥
generate_ssh_keys() {
    local -r ssh_dir="$HOME/.ssh"
    local -r private_key_file="$ssh_dir/id_rsa"
    local -r public_key_file="$ssh_dir/id_rsa.pub"

    if [ -f "$private_key_file" ] || [ -f "$public_key_file" ]; then
        log "SSH 公私钥已存在。"
    else
        log "正在生成 SSH 公私钥..."
        ssh-keygen -t rsa -b 4096 -f "$private_key_file" -N "" -q
        log "SSH 公私钥已生成。"
    fi

    log "公钥内容："
    cat "$public_key_file"
}

generate_ssh_keys

# 完成提示
check_version "初始化完成！"

# 删除代理
export http_proxy=
export https_proxy=
