# 安装软件开发中必要的软件


### 直接安装

**安装前提需要设置代理**
```shell
export http_proxy=xxx
export https_proxy=xxx
```

**mac 快速安装基础开发环境**
```shell
/bin/zsh -c "$(curl -o- https://raw.githubusercontent.com/ansike/init/master/src/install/macos/install.sh)"
```

### 软件清单
1. git
2. docker
3. ssh
4. 前端系列
   1. nvm (nvm install 16.14.0)
   2. yarn, pnpm (npm config set registry https://registry.npmmirror.com/ | yarn config set registry https://registry.npmmirror.com/)
   4. @vue/cli
   5. create-react-app
   6. http-server
5. pyenv(python)
6. 工具
   1. chrome
   2. vscode
   3. mac
      1. xcode-select
      2. brew
      3. iterm2
      4. alfred


