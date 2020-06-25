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

#检查参数的函数
function check() {
    #端口
    Port=$(grep -i "Port " $configfile)
    if [[ -z $Port || ${Port:0:1} == "#" ]]; then
        echo -e "Port 22"
    else
        echo -e "$Port"
    fi

    #密码登陆
    PasswordAuthentication=$(grep -i "PasswordAuthentication " $configfile)
    if [[ -z $PasswordAuthentication || ${PasswordAuthentication:0:1} == "#" ]]; then
        echo -e "PasswordAuthentication$red未配置$reset"
    else
        echo -e "$PasswordAuthentication"
    fi

    #密码为空的用户登陆
    PermitEmptyPasswords=$(grep -i "PermitEmptyPasswords " $configfile)
    if [[ -z $PermitEmptyPasswords || ${PermitEmptyPasswords:0:1} == "#" ]]; then
        echo -e "PermitEmptyPasswords$red未配置$reset"
    else
        echo -e "$PermitEmptyPasswords"
    fi

    #日志等级调整为INFO
    LogLevel=$(grep -i "LogLevel " $configfile)
    if [[ -z $LogLevel || ${LogLevel:0:1} == "#" ]]; then
        echo -e "LogLevel$red未配置$reset"
    else
        echo -e "$LogLevel"
    fi

    #使用SSH-2协议
    Protocol=$(grep -i "Protocol " $configfile)
    if [[ -z $Protocol || ${Protocol:0:1} == "#" ]]; then
        echo -e "Protocol$red未配置$reset"
    else
        echo -e "$Protocol"
    fi

    #每个连接最大允许的认证次数
    MaxAuthTries=$(grep -i "MaxAuthTries " $configfile)
    if [[ -z $MaxAuthTries || ${MaxAuthTries:0:1} == "#" ]]; then
        echo -e "MaxAuthTries$red未配置$reset"
    else
        echo -e "$MaxAuthTries"
    fi

    #是否通过创建非特权子进程处理接入请求的方法来进行权限分离。默认值是"yes"
    #认证成功后，将以该认证用户的身份创另一个子进程
    #这样做的目的是为了防止通过有缺陷的子进程提升权限，从而使系统更加安全
    UsePrivilegeSeparation=$(grep -i "UsePrivilegeSeparation " $configfile)
    if [[ -z $UsePrivilegeSeparation || ${UsePrivilegeSeparation:0:1} == "#" ]]; then
        echo -e "UsePrivilegeSeparation$red未配置$reset"
    else
        echo -e "$UsePrivilegeSeparation"
    fi

    #限制用户必须在指定的时限(单位秒)内认证成功
    LoginGraceTime=$(grep -i "LoginGraceTime " $configfile)
    if [[ -z $LoginGraceTime || ${LoginGraceTime:0:1} == "#" ]]; then
        echo -e "LoginGraceTime$red未配置$reset"
    else
        echo -e "$LoginGraceTime"
    fi

    #要求sshd(8)在接受连接请求前对用户主目录和相关的配置文件进行宿主和权限检查
    StrictModes=$(grep -i "StrictModes " $configfile)
    if [[ -z $StrictModes || ${StrictModes:0:1} == "#" ]]; then
        echo -e "StrictModes$red未配置$reset"
    else
        echo -e "$StrictModes"
    fi

    #公钥认证，仅可用于SSH-2
    PubkeyAuthentication=$(grep -i "PubkeyAuthentication " $configfile)
    if [[ -z $PubkeyAuthentication || ${PubkeyAuthentication:0:1} == "#" ]]; then
        echo -e "PubkeyAuthentication$red未配置$reset"
    else
        echo -e "$PubkeyAuthentication"
    fi

    #最大允许保持多少个未认证的连接：达到最大连接后拒绝连接尝试的概率：未认证的连接数量达到此值拒绝所有连接尝试
    MaxStartups=$(grep -i "MaxStartups " $configfile)
    if [[ -z $MaxStartups || ${MaxStartups:0:1} == "#" ]]; then
        echo -e "MaxStartups$red未配置$reset"
    else
        echo -e "$MaxStartups"
    fi
    #禁止将IP逆向解析为主机名，然后比对正向解析的结果，防止客户端欺骗
    UseDNS=$(grep -i "UseDNS " $configfile)
    if [[ -z $UseDNS || ${UseDNS:0:1} == "#" ]]; then
        echo -e "UseDNS$red未配置$reset"
    else
        echo -e "$UseDNS"
    fi
}

############检查参数###############
check

echo -en "$green开始优化(Y\N):$reset"
read -r temp
if [[ $temp == "y" || $temp == "y" ]]; then
    #############################开始优化#################################
    echo -e "#######################################"
    #端口
    if [[ -z $Port ]]; then
        echo -e "Port 2233" >>$configfile
    else
        sed -i "s/$Port/Port 2233/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "Port修改成功"
    else
        echo -e "Port修改失败"
    fi
    #密码登陆
    if [[ -z $PasswordAuthentication ]]; then
        echo -e "PasswordAuthentication no" >>$configfile
    else
        sed -i "s/$PasswordAuthentication/PasswordAuthentication no/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "PasswordAuthentication修改成功"
    else
        echo -e "PasswordAuthentication修改失败"
    fi
    #密码为空的用户登陆
    if [[ -z $PermitEmptyPasswords ]]; then
        echo -e "PermitEmptyPasswords no" >>$configfile
    else
        sed -i "s/$PermitEmptyPasswords/PermitEmptyPasswords no/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "PermitEmptyPasswords修改成功"
    else
        echo -e "PermitEmptyPasswords修改失败"
    fi
    #日志等级调整为INFO
    if [[ -z $LogLevel ]]; then
        echo -e "LogLevel INFO" >>$configfile
    else
        sed -i "s/$LogLevel/LogLevel INFO/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "LogLevel修改成功"
    else
        echo -e "LogLevel修改失败"
    fi
    #使用SSH-2协议
    if [[ -z $Protocol ]]; then
        echo -e "Protocol 2" >>$configfile
    else
        sed -i "s/$Protocol/Protocol 2/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "Protocol修改成功"
    else
        echo -e "Protocol修改失败"
    fi
    #每个连接最大允许的认证次数
    if [[ -z $MaxAuthTries ]]; then
        echo -e "MaxAuthTries 3" >>$configfile
    else
        sed -i "s/$MaxAuthTries/MaxAuthTries 3/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "MaxAuthTries修改成功"
    else
        echo -e "MaxAuthTries修改失败"
    fi
    #是否通过创建非特权子进程处理接入请求的方法来进行权限分离。默认值是"yes"
    #认证成功后，将以该认证用户的身份创另一个子进程
    #这样做的目的是为了防止通过有缺陷的子进程提升权限，从而使系统更加安全
    if [[ -z $UsePrivilegeSeparation ]]; then
        echo -e "UsePrivilegeSeparation yes" >>$configfile
    else
        sed -i "s/$UsePrivilegeSeparation/UsePrivilegeSeparation yes/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "UsePrivilegeSeparation修改成功"
    else
        echo -e "UsePrivilegeSeparation修改失败"
    fi
    #限制用户必须在指定的时限(单位秒)内认证成功
    if [[ -z $LoginGraceTime ]]; then
        echo -e "LoginGraceTime 60" >>$configfile
    else
        sed -i "s/$LoginGraceTime/LoginGraceTime 60/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "LoginGraceTime修改成功"
    else
        echo -e "LoginGraceTime修改失败"
    fi
    #要求sshd(8)在接受连接请求前对用户主目录和相关的配置文件进行宿主和权限检查
    if [[ -z $StrictModes ]]; then
        echo -e "StrictModes yes" >>$configfile
    else
        sed -i "s/$StrictModes/StrictModes yes/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "StrictModes修改成功"
    else
        echo -e "StrictModes修改失败"
    fi
    #公钥认证，仅可用于SSH-2
    if [[ -z $PubkeyAuthentication ]]; then
        echo -e "PubkeyAuthentication yes" >>$configfile
    else
        sed -i "s/$PubkeyAuthentication/PubkeyAuthentication yes/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "PubkeyAuthentication修改成功"
    else
        echo -e "PubkeyAuthentication修改失败"
    fi
    #最大允许保持多少个未认证的连接：达到最大连接后拒绝连接尝试的概率：未认证的连接数量达到此值拒绝所有连接尝试
    if [[ -z $MaxStartups ]]; then
        echo -e "MaxStartups 5:50:10" >>$configfile
    else
        sed -i "s/$MaxStartups/MaxStartups 5:50:10/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "MaxStartups修改成功"
    else
        echo -e "MaxStartups修改失败"
    fi
    #禁止将IP逆向解析为主机名，然后比对正向解析的结果，防止客户端欺骗
    if [[ -z $UseDNS ]]; then
        echo -e "UseDNS no" >>$configfile
    else
        sed -i "s/$UseDNS/UseDNS no/g" $configfile
    fi
    if [[ $? == 0 ]]; then
        echo -e "UseDNS修改成功"
    else
        echo -e "UseDNS修改失败"
    fi
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
