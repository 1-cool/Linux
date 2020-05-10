######################################################################################################
#                                        系统：debian
######################################################################################################

#!/bin/sh
# 禁止SSH密码登录
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
sed -i 's/#LogLevel INFO/LogLevel INFO/g' /etc/ssh/sshd_config
echo "Protocol 2" &>> /etc/ssh/sshd_config
sed -i 's/#MaxAuthTries 6/MaxAuthTries 3/g' /etc/ssh/sshd_config
systemctl restart sshd.service
# 下载准备脚本
cd /root/
wget https://raw.githubusercontent.com/1-cool/Linux/master/ready.sh
bash ready.sh
# 安装mtr screen ftp
sudo apt install -y mtr screen ftp
