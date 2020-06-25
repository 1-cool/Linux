#!/bin/bash
###########################################################
#                   系统：Debian
#                   加固SSH的安全
###########################################################

green='\e[32m'
red='\e[31m'
reset='\e[0m'

#sshd配置文件位置
configfile=/etc/ssh/sshd_config

checkstr=(
    #端口
    "Port "
    #密码登陆
    "PasswordAuthentication "
    #密码为空的用户登陆
    "PermitEmptyPasswords "
    #日志等级调整为INFO
    "LogLevel "
    #使用SSH-2协议
    "Protocol "
    #每个连接最大允许的认证次数
    "MaxAuthTries "
    #是否通过创建非特权子进程处理接入请求的方法来进行权限分离。默认值是"yes"
    #认证成功后，将以该认证用户的身份创另一个子进程
    #这样做的目的是为了防止通过有缺陷的子进程提升权限，从而使系统更加安全
    "UsePrivilegeSeparation "
    #限制用户必须在指定的时限(单位秒)内认证成功
    "LoginGraceTime "
    #要求sshd(8)在接受连接请求前对用户主目录和相关的配置文件进行宿主和权限检查
    "StrictModes "
    #公钥认证，仅可用于SSH-2
    "PubkeyAuthentication "
    #最大允许保持多少个未认证的连接：达到最大连接后拒绝连接尝试的概率：未认证的连接数量达到此值拒绝所有连接尝试
    "MaxStartups "
    #禁止将IP逆向解析为主机名，然后比对正向解析的结果，防止客户端欺骗
    "UseDNS "
)
length=${#checkstr[*]}

#检查参数的函数
function check() {
    for ((i = 0; i < length; i++)); do
        result[i]=$(grep -i "${checkstr[i]}" $configfile)
        # echo "${result[i]}"
        if [[ $(echo "${result[i]}" | wc -l) -gt 1 ]]; then
            result[i]=$(echo "${result[i]}" | grep -v "#")
            sed -i "/#${checkstr[i]}/d" $configfile
        fi
        if [[ -z ${result[i]} || ${result[i]:0:1} == "#" ]]; then
            echo -e "${checkstr[i]}${red}未配置${reset}"
        else
            echo -e "${result[i]}"
        fi
    done
}

############检查参数###############
check

echo -en "$green开始优化(Y\N):$reset"
read -r temp
if [[ $temp == "y" || $temp == "y" ]]; then
    #############################开始优化#################################
    echo -e "#######################################"
    for ((i = 0; i < length; i++)); do
        if [[ -z ${result[i]} ]]; then
            if [[ ${checkstr[i]} == "Port " ]]; then
                echo "Port 2233" >>${configfile}
            elif [[ ${checkstr[i]} == "PasswordAuthentication " || ${checkstr[i]} == "PermitEmptyPasswords " || ${checkstr[i]} == "UseDNS " ]]; then
                echo "${checkstr[i]}no" >>${configfile}
            elif [[ ${checkstr[i]} == "LogLevel " ]]; then
                echo "LogLevel INFO" >>${configfile}
            elif [[ ${checkstr[i]} == "Protocol " ]]; then
                echo "Protocol 2" >>$configfile
            elif [[ ${checkstr[i]} == "MaxAuthTries " ]]; then
                echo "MaxAuthTries 3" >>$configfile
            elif [[ ${checkstr[i]} == "UsePrivilegeSeparation " || ${checkstr[i]} == "StrictModes " || ${checkstr[i]} == "PubkeyAuthentication " ]]; then
                echo "${checkstr[i]}yes" >>$configfile
            elif [[ ${checkstr[i]} == "LoginGraceTime " ]]; then
                echo "LoginGraceTime 60" >>$configfile
            elif [[ ${checkstr[i]} == "MaxStartups " ]]; then
                echo "MaxStartups 5:50:10" >>$configfile
            fi

        else
            if [[ ${checkstr[i]} == "Port " ]]; then
                sed -i "s/${result[i]}/Port 2233/g" $configfile
            elif [[ ${checkstr[i]} == "PasswordAuthentication " || ${checkstr[i]} == "PermitEmptyPasswords " || ${checkstr[i]} == "UseDNS " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}no/g" $configfile
            elif [[ ${checkstr[i]} == "LogLevel " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}INFO/g" $configfile
            elif [[ ${checkstr[i]} == "Protocol " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}2/g" $configfile
            elif [[ ${checkstr[i]} == "MaxAuthTries " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}3/g" $configfile
            elif [[ ${checkstr[i]} == "UsePrivilegeSeparation " || ${checkstr[i]} == "StrictModes " || ${checkstr[i]} == "PubkeyAuthentication " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}yes/g" $configfile
            elif [[ ${checkstr[i]} == "LoginGraceTime " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}60/g" $configfile
            elif [[ ${checkstr[i]} == "MaxStartups " ]]; then
                sed -i "s/${result[i]}/${checkstr[i]}5:50:10/g" $configfile
            fi
        fi
    done
else
    exit 0
fi


############检查参数###############
check


echo "#######################################"
echo -en "是否现在生效(Y\N):"
read -r temp
#重启sshd服务，使配置生效
if [[ $temp == "Y" || $temp == "y" ]]; then
    systemctl restart sshd.service
fi
