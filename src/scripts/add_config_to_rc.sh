#!/bin/bash

add_config_to_rc() {
    local config="$1"
    local shell_name="$SHELL"

    if [ -n "$shell_name" ]; then
        if [[ "$shell_name" == *"bash"* ]]; then
            local shell_rc="$HOME/.bashrc"
        elif [[ "$shell_name" == *"zsh"* ]]; then
            local shell_rc="$HOME/.zshrc"
        else
            echo "Unsupported shell: $shell_name"
            return
        fi
        if [ -n "$shell_rc" ] && [ -f "$shell_rc" ]; then
            # 判断已经设置上
            if ! cat $shell_rc | grep -F "$config" ; then
                echo "$config" >> "$shell_rc"
                echo "Added configuration to $shell_rc"
            else
                echo "Configuration already exists in $shell_rc"
            fi
        else
            echo "Shell configuration file not found: $shell_rc"
        fi
    else
        echo "Unable to determine user's shell."
    fi
}

nvm_config1='export NVM_DIR="$HOME/.nvm"'
nvm_config2='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
nvm_config3='[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

add_config_to_rc "$nvm_config1"
add_config_to_rc "$nvm_config2"
add_config_to_rc "$nvm_config3"
