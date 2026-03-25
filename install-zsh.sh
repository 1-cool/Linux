#!/bin/bash
######################################################################################################
#                                        安装zsh和oh-my-zsh
######################################################################################################

# 安装 zsh git curl
apt install zsh git curl -y

#安装 oh-my-zsh
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"

#插件安装

#zsh-autosuggestions 是一个命令提示插件，当你输入命令时，会自动推测你可能需要输入的命令，按下右键可以快速采用建议。
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://gh-proxy.org/https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#zsh-syntax-highlighting 是一个命令语法校验插件，在输入命令的过程中，若指令不合法，则指令显示为红色，若指令合法就会显示为绿色。
git clone https://gh-proxy.org/https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#启用插件
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting extract)/' ~/.zshrc

#让配置生效
source ~/.zshrc
