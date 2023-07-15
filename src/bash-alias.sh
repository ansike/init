#/bin/bash

# 当前文件适合系统进行初始化的场景

# 获取当前脚本所在的目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# 引入 check_app.sh 脚本
source "${SCRIPT_DIR}/utils/check_app.sh"

echo "开始设置 bash alias"
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

if checkAppIsInstalled "git"; then
    echo "git 已安装, 开始设置 git alias"
    git config --global alias.st status
    git config --global alias.aa "add ."
    git config --global alias.ck checkout
    git config --global alias.cm "commit -m"
    git config --global alias.br branch
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
else
    echo "git 未安装, 需要安装之后重新运行该shell"
fi


echo "！！！配置完成！！！"