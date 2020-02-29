######################################################################
#                            ready install web
######################################################################

#!/bin/bash

#init config
wget https://raw.githubusercontent.com/1-cool/Linux/master/initconfig.sh
chmod +x initconfig.sh
./initconfig.sh
rm initconfig.sh
#准备网络加速安装脚本
wget https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh
chmod +x tcp.sh

#准备宝塔安装脚本
wget http://download.bt.cn/install/install-ubuntu_6.0.sh

