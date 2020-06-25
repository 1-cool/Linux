#!/bin/sh
######################################################################################################
#                                        系统：debian
######################################################################################################


# 禁止SSH密码登录
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd.service
# 安装mtr
sudo apt install -y mtr
