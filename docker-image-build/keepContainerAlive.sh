#!/usr/bin/env bash

binPath=$(echo ${BIN_PATH})

emptyPeriod=300
checkPeriod=3

monitorCheck() {
    while :
    do
	    cur_dateTime=`date +%Y-%m-%d#%H:%M:%S`
		isRuning=$(ps aux | grep monitor.sh | grep -v grep | awk {'print("monitorMem=%s; monitorStatus=%s; monitorName=%s", $4, $8, $11)'})
        if [ "$isRuning" ]; then
            echo "[INFO] $cur_dateTime monitor.sh is runing, break to keep container alive"
            break
        else
            echo "[WARN] $cur_dateTime monitor.sh is not runing, begin start..."
        
            nohup $binPath/monitor.sh >> /root/service/log/nohup.log 2>&1 &
        fi
    
        sleep $checkPeriod
    done
}
monitorCheck

while :
do
    sleep $emptyPeriod
done
