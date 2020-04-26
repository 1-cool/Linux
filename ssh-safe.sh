###########################################################
#                   系统：Debian
#                   加固SSH的安全
###########################################################
#!/bin/bash
#sshd配置文件位置
configfile=/etc/ssh/sshd_config

#端口
Port=$(grep -i "Port " $configfile)
echo $Port

#密码登陆
PasswordAuthentication=$(grep -i "PasswordAuthentication " $configfile)
echo $PasswordAuthentication

#密码为空的用户登陆
PermitEmptyPasswords=$(grep -i "PermitEmptyPasswords " $configfile)
echo $PermitEmptyPasswords

#日志等级调整为INFO
LogLevel=$(grep -i "LogLevel " $configfile)
echo $LogLevel

#使用SSH-2协议
Protocol=$(grep -i "Protocol " $configfile)
echo $Protocol

#每个连接最大允许的认证次数
MaxAuthTries=$(grep -i "MaxAuthTries " $configfile)
echo $MaxAuthTries

#是否通过创建非特权子进程处理接入请求的方法来进行权限分离。默认值是"yes"
#认证成功后，将以该认证用户的身份创另一个子进程
#这样做的目的是为了防止通过有缺陷的子进程提升权限，从而使系统更加安全
UsePrivilegeSeparation=$(grep -i "UsePrivilegeSeparation " $configfile)
echo $UsePrivilegeSeparation

#限制用户必须在指定的时限(单位秒)内认证成功
LoginGraceTime=$(grep -i "LoginGraceTime " $configfile)
echo $LoginGraceTime

#要求sshd(8)在接受连接请求前对用户主目录和相关的配置文件进行宿主和权限检查
StrictModes=$(grep -i "StrictModes " $configfile)
echo $StrictModes

#公钥认证，仅可用于SSH-2
PubkeyAuthentication=$(grep -i "PubkeyAuthentication " $configfile)
echo $PubkeyAuthentication

#最大允许保持多少个未认证的连接：达到最大连接后拒绝连接尝试的概率：未认证的连接数量达到此值拒绝所有连接尝试
MaxStartups=$(grep -i "MaxStartups " $configfile)
echo $MaxStartups



#重启sshd服务，使配置生效
# systemctl restart sshd.service