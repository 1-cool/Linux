#!/bin/bash
############################################################################
#                             查看v2ray连接列表
############################################################################

#读取v2ray端口
PORT=$(grep \"port /etc/v2ray/config.json | tr -cd "[0-9]")
#读取连接列表
LIST=$(lsof -i -n -P | grep ESTABLISHED | grep ${PORT} | awk '{print $9}' | awk -F '->' '{print $2}' | awk -F ':' '{print $1}' | sort -u)
if [ -z "${LIST}" ];
then
    echo "当前无连接"
else
    for IP in ${LIST}
    do
        #查询IP及归属地
        curl https://cip.cc/${IP}
    done
fi
