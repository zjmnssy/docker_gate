#!/usr/bin/env bash

monitorPeriod=5
retryTimes=3

hostIp=$(echo ${HOST_IP})
programName=$(echo ${PROGRAM_NAME})
startFlag=$(echo ${START_FLAG})
binPath=$(echo ${BIN_PATH})
configPath=$(echo ${CONFIG_PATH})
dataPath=$(echo ${DATA_PATH})
logPath=$(echo ${LOG_PATH})

oldLogPath="$binPath/.oldLogs"

createOldLogDirectory() {
    if [ ! -d "$oldLogPath" ]; then
        mkdir $oldLogPath
    else
        echo "[INFO] $oldLogPath exist, nothing to do"
    fi
}

Start() {
    echo "[INFO] begin run $programName"
    
    cur_dateTime=`date +%Y-%m-%d#%H:%M:%S`
    logFileName="service@$cur_dateTime.log"
    
    echo "[INFO] logFileName = $logFileName"
    
    nohup $binPath/$programName $startFlag >> $logPath/$logFileName 2>&1 &
}

Monitor() {
    startTryTimes=0
	
    while :
    do
        cur_dateTime=`date +%Y-%m-%d#%H:%M:%S`
        isRuning=$(ps aux | grep $programName | grep -v grep | awk {'print("programMem=%s; programStatus=%s; programName=%s", $4, $8, $11)'})
        if [ "$isRuning" ]; then
            echo "[INFO] $cur_dateTime $programName is runing, nothing need to do"
        else
            echo "[WARN] $cur_dateTime $programName is not runing, save old log and start $programName"
            ((startTryTimes++))
			
		    if [ "$startTryTimes" -ge "$retryTimes" ]; then
		    	echo "retry $startTryTimes but all failed"
	    	else 
		    	Start
		    fi
        fi

        sleep $monitorPeriod
	done
}



