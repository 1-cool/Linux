#用来测试服务器能否ping通国内IP 当能ping通的IP少于一定数量时，发邮件提醒


#!/bin/bash
#获取IP列表
HLIST=$(cat ipadds.txt)
#获取IP地址数量
total=$(wc -l ipadds.txt | awk '{print $1}')
#规定最大的延迟
maxtime=400.000
#低于最大延迟的IP数
GOOD=0
#安装所需支持
sudo apt install -y bc sendemail libnet-ssleay-perl libio-socket-ssl-perl
for IP in ${HLIST}
do
        #获取延迟
        TIME=$(ping -c 1 -i 0.2 -W 3 ${IP} | awk '{print $7}' | awk '{split($0,b,"=");print b[2]}')
        #判断延迟是否小于规定的最大延迟
        if [[ -n ${TIME} ]] && [[ $(echo "${TIME} < ${maxtime}"|bc) -eq 1 ]];
        then
                let "GOOD=GOOD+1"
        fi
done
echo "测试主机共${total}台"
#取总IP数的1/5
#let "total=total/5"
echo "现能良好连接的主机${GOOD}台"
#判断好的延迟数目是否低于总IP的1/5
if [ ${GOOD} -lt ${total} ];
then
        echo "Bad"
        sendemail -l email.log -f "****@qq.com" -u "subject" -t "****@qq.com" -s "smtp.qq.com:587" -o tls=yes -xu "xxx@qq.com" -xp "password" -m "总共${total}台主机,现在能良好连接主机${GOOD}台"
        # -l 保存日志到email.log文件
        # -f 发生邮件的邮箱地址
        # -u 邮件主题
        # -t 接收邮件的邮箱地址
        # -s SMTP地址
        # -o tls=yes 开启SSL加密
        # -xu SMTP验证的用户名
        # -xp SMTP验证的密码
        # -m 邮件内容
else
        echo "Good"
fi
