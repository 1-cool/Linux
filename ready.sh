######################################################################
#                            准备Linux安装脚本
######################################################################

#!/bin/bash

red='\033[0;31m'

#检查权限
[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] 需要root权限执行此脚本!" && exit 1

#准备SS脚本
wget https://raw.githubusercontent.com/1-cool/Linux/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh

#准备网络加速脚本
wget https://raw.githubusercontent.com/dlxg/Linux-NetSpeed/master/tcp.sh
chmod +x tcp.sh

#准备SSH端口更改脚本
wget https://raw.githubusercontent.com/1-cool/Linux/master/ssh-port.sh
chmod +x ssh-port.sh
