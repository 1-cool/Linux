######################################################################
#                            准备Linux安装脚本
######################################################################

#!/bin/bash

#准备SS/SSR安装脚本
wget https://raw.githubusercontent.com/1-cool/Linux/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh

#准备网络加速安装脚本
wget https://raw.githubusercontent.com/dlxg/Linux-NetSpeed/master/tcp.sh
chmod +x tcp.sh

#准备SSH端口更改脚本
wget https://raw.githubusercontent.com/1-cool/Linux/master/ssh-port.sh
chmod +x ssh-port.sh

#准备宝塔安装脚本
wget http://download.bt.cn/install/install-ubuntu.sh
