# 在linux系统的环境下，不管是root用户还是其它的用户只要登陆系统后
# 进入操作我们都可以通过命令history来查看历史记录，可是假如一台服
# 务器多人登陆，一天因为某人误操作了删除了重要的数据。这时候通过查
# 看历史记录（命令：history）是没有什么意义了（因为history只针对登
# 录用户下执行有效，即使root用户也无法得到其它用户histotry历史）。
# 那有没有什么办法实现通过记录登陆后的IP地址和某用户名所操作的历史记录呢

# 通过在/etc/profile里面加入以下代码就可以实现：

PS1="`whoami`@`hostname`:"'[$PWD]'
history
USER_IP=`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`
if [ "$USER_IP" = "" ]
then
USER_IP=`hostname`
fi
if [ ! -d /tmp/dbasky ]
then
mkdir /tmp/dbasky
chmod 777 /tmp/dbasky
fi
if [ ! -d /tmp/dbasky/${LOGNAME} ]
then
mkdir /tmp/dbasky/${LOGNAME}
chmod 300 /tmp/dbasky/${LOGNAME}
fi
export HISTSIZE=4096
DT=`date "+%Y-%m-%d_%H:%M:%S"`
export HISTFILE="/tmp/dbasky/${LOGNAME}/${USER_IP} dbasky.$DT"
chmod 600 /tmp/dbasky/${LOGNAME}/*dbasky* 2>/dev/null