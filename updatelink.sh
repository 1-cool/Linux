#/bin/bash
#get vmess
vmess=$(v2ray url | sed -n '4p' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
echo -e "${vmess}\n"
#base64 encoding
link=$(echo -n "${vmess}" | base64 -w 0)
echo -e "${link}\n"
echo ${link} > /www/wwwroot/disk/link/link.txt