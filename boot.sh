#!/bin/bash
######################################################################################################
#                                        系统：Ubuntu
######################################################################################################


# 加固SSH的安全
curl -fsSL https://raw.githubusercontent.com/1-cool/Linux/refs/heads/master/ssh-safe.sh | bash

# 安装zsh和oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/1-cool/Linux/refs/heads/master/install-zsh.sh | bash

# 安装和配置fail2ban
curl -fsSL https://raw.githubusercontent.com/1-cool/Linux/refs/heads/master/fail2ban.sh | bash

# 安装谷歌浏览器
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# 下载.vimrc
wget -O ~/.vimrc https://raw.githubusercontent.com/1-cool/Linux-config/refs/heads/master/.vimrc
mkdri -p $HOME/.vim/backup/
mkdri -p $HOME/.vim/swap/
mkdri -p $HOME/.vim/undo/
