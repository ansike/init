#!/bin/bash

# 检查软件是否已经安装
check_installed() {
    command -v "$1" &> /dev/null
}

# 安装Homebrew（如果尚未安装）
if ! check_installed brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 安装Git
if ! check_installed git; then
    brew install git
fi

# 安装Node.js
if ! check_installed node; then
    brew install node
fi

# 安装Yarn
if ! check_installed yarn; then
    brew install yarn
fi

# 安装pnpm
if ! check_installed pnpm; then
    brew install pnpm
fi

# 安装@vue/cli
if ! check_installed vue; then
    yarn global add @vue/cli
fi

# 安装create-react-app
if ! check_installed create-react-app; then
    yarn global add create-react-app
fi

# 安装http-server
if ! check_installed http-server; then
    npm install -g http-server
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
