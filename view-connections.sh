############################################################################
#                             查看v2ray连接列表
############################################################################
#读取v2ray端口
PORT=$(grep \"port /etc/v2ray/config.json | tr -cd "[0-9]")
#读取连接列表
LIST=$(lsof -i -n -P | grep ESTABLISHED | grep $PORT | awk '{print $9}' | awk -F '->' '{print $2}' | awk -F ':' '{print $1}' | sort -u)
for IP in $LIST
do
        #显示连接v2ray的IP
        echo $IP
done
for IP in $LIST
do
        #查询IP归属地
        curl https://ip.cn/index.php?ip=$IP
done
