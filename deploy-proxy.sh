#!/bin/bash
#################################################################################
#                         install v2ray and update link
#################################################################################
red='\e[91m'
none='\e[0m'
#root
[[ $(id -u) != 0 ]] && echo -e "\n ${red}请使用 root 用户运行${none} \n" && exit 1
#download and install v2ray
wget https://raw.githubusercontent.com/1-cool/Linux/master/v2ray.sh
chmod +x v2ray.sh
./v2ray.sh
#get vmess
vmess=$(v2ray url | sed -n '4p' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
echo -e "${vmess}\n"
#base64 encoding
link=$(echo -n "${vmess}" | base64 -w 0)
echo -e "${link}\n"
echo ${link} > link.txt
#install ftp
apt install -y ftp
#ftp upload
ftp -n 202.182.109.206<<EOF
user ftpname ftppass
hash
put link.txt
bye
EOF