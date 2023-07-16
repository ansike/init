#!/bin/bash

# 检查软件是否已经安装
check_installed() {
    command -v "$1" &> /dev/null
}

# 输出日志信息
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# 显示进度
show_progress() {
    local -r pid=$1
    local -r delay=0.5
    local spin='-\|/'
    local i=0

    log "正在安装中，请稍候..."

    while kill -0 $pid 2>/dev/null; do
        local i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1}"
        sleep $delay
    done

    printf "\r"
}

###############
# 检查 Xcode 是否已安装
###############
if ! check_installed xcode-select; then
    log "Xcode未找到，正在安装Xcode..."

    # 安装 Xcode Command Line Tools
    xcode-select --install &>/dev/null

    # 显示安装进度
    show_progress $!

    log "Xcode安装完成。"
fi

[ $? -eq 0 ] && log "Xcode pass"

###############
# 安装Homebrew（如果尚未安装）
###############
if ! check_installed brew; then
    log "正在安装Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>/dev/null

    log "Homebrew安装完成。"
fi

###############
# 安装&配置Git
###############
# 检查 unzip 是否已安装
if ! check_installed unzip; then
    log "unzip未找到，正在安装unzip..."

    # 安装 unzip
    brew install unzip &>/dev/null

    log "unzip安装完成。"
fi

###############
# 安装&配置Git
###############
if ! check_installed git; then
    brew install git
fi

###############
# 安装nvm
###############
if ! check_installed nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

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

    log "VSCode安装完成。"
fi


# 安装@vue/cli
if ! check_installed vue; then
    yarn global add @vue/cli
fi

# 安装create-react-app
if ! check_installed create-react-app; then
    yarn global add create-react-app
fi

# 安装Python（使用pyenv管理多个版本）
if ! check_installed pyenv; then
    brew install pyenv

    # 添加pyenv到bashrc或者zshrc配置文件（如果尚未添加）
    if ! grep -q "pyenv init" ~/.zshrc || ! grep -q "pyenv virtualenv-init" ~/.zshrc; then
        echo 'if command -v pyenv 1>/dev/null 2>&1; then' >> ~/.zshrc
        echo '  eval "$(pyenv init --path)"' >> ~/.zshrc
        echo '  eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
        echo 'fi' >> ~/.zshrc
    fi

    # 安装最新的Python版本
    if ! pyenv versions | grep -q "^\s*$(pyenv install --list | grep -v - | tail -1)"; then
        pyenv install $(pyenv install --list | grep -v - | tail -1)
    fi

    # 设置全局Python版本
    pyenv global $(pyenv versions --bare | tail -1)
fi

# 安装Docker（如果尚未安装）
if ! check_installed docker; then
    if [ ! -f "/usr/local/bin/docker" ]; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
    fi
fi

# 安装OpenSSH（通常已经安装）
if ! check_installed ssh; then
    brew install openssh
fi

# 完成提示
echo "初始化完成！"
