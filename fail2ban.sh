#!/bin/bash
######################################################################################################
#                                        安装和配置fail2ban
######################################################################################################

#安装fail2ban
apt install -y fail2ban

#写入配置
tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = -1
findtime = 60
EOF

#启动服务
systemctl start fail2ban

#设置开机自启
systemctl enable fail2ban


