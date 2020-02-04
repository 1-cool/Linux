############################################################################
#                             查看v2ray连接列表
############################################################################
#!/bin/bash
port=$(grep \"port /etc/v2ray/config.json | tr -cd "[0-9]")
lsof -i -n -P | grep ESTABLISHED | grep ${port} | awk '{print $9}' | awk -F '->' '{print $2}' | awk -F ':' '{print $1}' | sort -u
