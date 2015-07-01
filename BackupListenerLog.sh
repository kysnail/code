
#!/bin/bash
LLOGFILE=`lsnrctl status |grep -i "Listener Log File" |awk  '{print $4}'` 
LOGSIZE=`du -sm $LLOGFILE | awk  '{print $1}'`
STSIZE=1024
BAKDATE=`date +%Y%m%d` 
if [ $LOGSIZE -lt $STSIZE ]
then
echo "LISTENER LOGFILE IS LESS THEN 1G"
elif [ $LOGSIZE -ge $STSIZE ] 
then
lsnrctl set log_status off
mv  $LLOGFILE $LLOGFILE.$BAKDATE
gzip -9 $$LLOGFILE.$BAKDATE
sleep 10
lsnrctl set log_status on
fi

# Listener.log 日志文件过大不利于 Oracle 数据库的正常运行，所以定期
# 清空 Listener.log 信息就显得很重要了。