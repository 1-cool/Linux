############################################################################
#                             查看v2ray连接列表
############################################################################
PORT=$(grep \"port /etc/v2ray/config.json | tr -cd "[0-9]")
LIST=$(lsof -i -n -P | grep ESTABLISHED | grep $PORT | awk '{print $9}' | awk -F '->' '{print $2}' | awk -F ':' '{print $1}' | sort -u)
for IP in $LIST
do
        curl https://ip.cn/index.php?ip=$IP
done
