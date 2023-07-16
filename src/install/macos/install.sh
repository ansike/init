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

###############
# 检查 Xcode 是否已安装
###############
order='xcode-select'
if ! check_installed $order; then
    log "Xcode未找到，正在安装Xcode..."

    # 安装 Xcode Command Line Tools
    xcode-select --install &>/dev/null

    [ $? -eq 0 ] && log "${order}安装完成。" || log "${order}安装失败。"
fi

check_version $(xcode-select -v)

###############
# 安装Homebrew（如果尚未安装）
###############
order='brew'
if ! check_installed $order; then
    log "正在安装$order..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    [ $? -eq 0 ] && log "${order}安装完成。" || log "${order}安装失败。"
fi

check_version $(brew -v)

# 切换到zsh
[ $SHELL != "/bin/zsh" ] && {
    log "当前环境的shell为$SHELL, 切换到zsh"
    chsh -s /bin/zsh
} || log "当前环境shell为 zsh"

###############
# 安装oh-my-zsh
###############
if ! cat ~/.zshrc | grep "oh-my-zsh" >/dev/null ; then
    log "正在安装oh-my-zsh..."

    /bin/bash -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    [ $? -eq 0 ] && log "oh-my-zsh安装完成。" || log "oh-my-zsh安装失败。"
fi

###############
# 检查 unzip 是否已安装
###############
order='unzip'
if ! check_installed $order; then
    log "$order未找到，正在安装$order..."

    # 安装 $order
    brew install $order &>/dev/null

    [ $? -eq 0 ] && log "${order}安装完成。" || log "${order}安装失败。"
fi

check_version $(unzip -v | head -n 1)

###############
# 安装&配置Git
###############
order='git'
if ! check_installed $order; then
    brew install $order
fi

check_version $(git -v)

# if check_installed "git" && ! git config --global --get alias.st >/dev/null 2>&1; then
if check_installed "git" && [ -z "$(git config --global --get alias.st)" ]; then
    log "git 已安装, 开始设置 git alias"
    git config --global alias.st status
    git config --global alias.aa "add ."
    git config --global alias.ck checkout
    git config --global alias.cm "commit -m"
    git config --global alias.br branch
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
fi

###############
# 安装nvm
###############
source ~/.zshrc
order='nvm'
if ! check_installed nvm; then
    log "正在安装 $order ..."

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

    [ $SHELL == '/bin/zsh' ] && source ~/.zshrc || {
        source ~/.bashrc
        source ~/.profile
        source ~/.bash_profile
    }
    [ $? -eq 0 ] && log "${order}安装完成。" || log "${order}安装失败。"
fi

check_version "nvm" $(nvm -v)

###############
# 检查 VSCode 是否已安装
###############
if ! check_installed code; then
    log "VSCode未找到，正在安装VSCode..."

    # 下载安装包
    curl -o vscode.zip -L https://code.visualstudio.com/sha/download\?build\=stable\&os\=darwin-universal

    # 解压缩安装包
    unzip vscode.zip

    # 安装 VSCode
    sudo mv "Visual Studio Code.app" "/Applications/"

    # 清理安装文件
    rm vscode.zip

    # 配置code命令
    sudo ln -s /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code /usr/local/bin/code

    log "VSCode安装完成。"
fi

check_version "vscode" $(code -v)

###############
# 安装 node
###############
order='node'
if ! check_installed $order; then
    nvm install 16.14.0
fi

check_version "node" $($order -v)
check_version "npm" $(npm -v)

###############
# 安装yarn
###############
order="yarn"
if ! check_installed $order; then
    npm i -g $order
fi

check_version "yarn" $($order -v)

###############
# 安装@vue/cli
###############
if ! check_installed vue; then
    yarn global -g @vue/cli
fi

check_version $(vue -V)

# 安装create-react-app
if ! check_installed create-react-app; then
    yarn global add create-react-app
fi
check_version "create-react-app" $(create-react-app -V)

# 安装Python（使用pyenv管理多个版本）
if ! check_installed pyenv; then
    brew install pyenv

    # 添加pyenv到bashrc或者zshrc配置文件（如果尚未添加）
    if ! grep -q "pyenv init" ~/.zshrc || ! grep -q "pyenv virtualenv-init" ~/.zshrc; then
        echo 'if command -v pyenv 1>/dev/null 2>&1; then' >>~/.zshrc
        echo '  eval "$(pyenv init --path)"' >>~/.zshrc
        echo '  eval "$(pyenv virtualenv-init -)"' >>~/.zshrc
        echo 'fi' >>~/.zshrc
    fi

    # 安装最新的Python版本
    if ! pyenv versions | grep -q "^\s*$(pyenv install --list | grep -v - | tail -1)"; then
        pyenv install $(pyenv install --list | grep -v - | tail -1)
    fi

    # 设置全局Python版本
    pyenv global $(pyenv versions --bare | tail -1)
fi

check_version $(pyenv -v)

# 安装Docker（如果尚未安装）
if ! check_installed docker; then
    brew install --cask --appdir=/Applications docker
fi

check_version $(docker -v)

# 安装OpenSSH（通常已经安装）
if ! check_installed ssh; then
    brew install openssh
fi

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
