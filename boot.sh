#!/bin/sh
# 禁止SSH密码登录
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd.service
# 下载准备脚本
cd /root/
wget https://raw.githubusercontent.com/1-cool/Linux/master/ready.sh
bash ready.sh
# 安装mtr
sudo apt install -y mtr
