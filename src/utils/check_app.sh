#/bin/bash

# 函数：checkAppIsInstalled
# 参数：
#   - $1: 要检查的软件名称
# 返回值：
#   - 0: 软件已安装
#   - 1: 软件未安装
checkAppIsInstalled() {
    command -v "$1" &> /dev/null
}