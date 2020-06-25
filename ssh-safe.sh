#!/bin/bash
###########################################################
#                   系统：Debian
#                   加固SSH的安全
###########################################################

green='\e[32m'
red='\e[31m'
reset='\e[0m'

#sshd配置文件位置
# configfile=/etc/ssh/sshd_config
configfile=/tmp/sshd_config

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

    # #端口
    # if [[ -z $Port ]]; then
    #     echo -e "Port 2233" >>$configfile
    # else
    #     sed -i "s/$Port/Port 2233/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "Port修改成功"
    # else
    #     echo -e "Port修改失败"
    # fi
    # #密码登陆
    # if [[ -z $PasswordAuthentication ]]; then
    #     echo -e "PasswordAuthentication no" >>$configfile
    # else
    #     sed -i "s/$PasswordAuthentication/PasswordAuthentication no/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "PasswordAuthentication修改成功"
    # else
    #     echo -e "PasswordAuthentication修改失败"
    # fi
    # #密码为空的用户登陆
    # if [[ -z $PermitEmptyPasswords ]]; then
    #     echo -e "PermitEmptyPasswords no" >>$configfile
    # else
    #     sed -i "s/$PermitEmptyPasswords/PermitEmptyPasswords no/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "PermitEmptyPasswords修改成功"
    # else
    #     echo -e "PermitEmptyPasswords修改失败"
    # fi
    # #日志等级调整为INFO
    # if [[ -z $LogLevel ]]; then
    #     echo -e "LogLevel INFO" >>$configfile
    # else
    #     sed -i "s/$LogLevel/LogLevel INFO/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "LogLevel修改成功"
    # else
    #     echo -e "LogLevel修改失败"
    # fi
    # #使用SSH-2协议
    # if [[ -z $Protocol ]]; then
    #     echo -e "Protocol 2" >>$configfile
    # else
    #     sed -i "s/$Protocol/Protocol 2/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "Protocol修改成功"
    # else
    #     echo -e "Protocol修改失败"
    # fi
    # #每个连接最大允许的认证次数
    # if [[ -z $MaxAuthTries ]]; then
    #     echo -e "MaxAuthTries 3" >>$configfile
    # else
    #     sed -i "s/$MaxAuthTries/MaxAuthTries 3/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "MaxAuthTries修改成功"
    # else
    #     echo -e "MaxAuthTries修改失败"
    # fi
    # #是否通过创建非特权子进程处理接入请求的方法来进行权限分离。默认值是"yes"
    # #认证成功后，将以该认证用户的身份创另一个子进程
    # #这样做的目的是为了防止通过有缺陷的子进程提升权限，从而使系统更加安全
    # if [[ -z $UsePrivilegeSeparation ]]; then
    #     echo -e "UsePrivilegeSeparation yes" >>$configfile
    # else
    #     sed -i "s/$UsePrivilegeSeparation/UsePrivilegeSeparation yes/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "UsePrivilegeSeparation修改成功"
    # else
    #     echo -e "UsePrivilegeSeparation修改失败"
    # fi
    # #限制用户必须在指定的时限(单位秒)内认证成功
    # if [[ -z $LoginGraceTime ]]; then
    #     echo -e "LoginGraceTime 60" >>$configfile
    # else
    #     sed -i "s/$LoginGraceTime/LoginGraceTime 60/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "LoginGraceTime修改成功"
    # else
    #     echo -e "LoginGraceTime修改失败"
    # fi
    # #要求sshd(8)在接受连接请求前对用户主目录和相关的配置文件进行宿主和权限检查
    # if [[ -z $StrictModes ]]; then
    #     echo -e "StrictModes yes" >>$configfile
    # else
    #     sed -i "s/$StrictModes/StrictModes yes/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "StrictModes修改成功"
    # else
    #     echo -e "StrictModes修改失败"
    # fi
    # #公钥认证，仅可用于SSH-2
    # if [[ -z $PubkeyAuthentication ]]; then
    #     echo -e "PubkeyAuthentication yes" >>$configfile
    # else
    #     sed -i "s/$PubkeyAuthentication/PubkeyAuthentication yes/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "PubkeyAuthentication修改成功"
    # else
    #     echo -e "PubkeyAuthentication修改失败"
    # fi
    # #最大允许保持多少个未认证的连接：达到最大连接后拒绝连接尝试的概率：未认证的连接数量达到此值拒绝所有连接尝试
    # if [[ -z $MaxStartups ]]; then
    #     echo -e "MaxStartups 5:50:10" >>$configfile
    # else
    #     sed -i "s/$MaxStartups/MaxStartups 5:50:10/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "MaxStartups修改成功"
    # else
    #     echo -e "MaxStartups修改失败"
    # fi
    # #禁止将IP逆向解析为主机名，然后比对正向解析的结果，防止客户端欺骗
    # if [[ -z $UseDNS ]]; then
    #     echo -e "UseDNS no" >>$configfile
    # else
    #     sed -i "s/$UseDNS/UseDNS no/g" $configfile
    # fi
    # if [[ $? == 0 ]]; then
    #     echo -e "UseDNS修改成功"
    # else
    #     echo -e "UseDNS修改失败"
    # fi
else
    exit 0
fi

echo -e "#######################################"

############检查参数###############
check

echo -en "是否现在生效(Y\N):"
read -r temp
#重启sshd服务，使配置生效
if [[ $temp == "Y" || $temp == "y" ]]; then
    systemctl restart sshd.service
fi
