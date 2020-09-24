#!/bin/bash
ReplicationTaskArn=` \
aws dms create-replication-task \
--replication-task-identifier orders40-79-task \
--source-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:RSICUHNZHGR3LEM774Q2HHPLIPDAG732YIRLEWQ \
--target-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:HUDRZ3O6WFZOJ3KFEIJLUY6J6F7NWXKJACIKGHQ \
--replication-instance-arn arn:aws:dms:ap-northeast-2:664695030410:rep:4UO7VATLK73OPWDGMFPW3R6SDKBCZH5OYRIDFEI \
--migration-type full-load \
--replication-task-settings file://orders001-task.json \
--table-mappings file://orders080.json |  jq -r '.ReplicationTask.ReplicationTaskArn'`

while true
do
 TASK_STATUS=`aws dms describe-replication-tasks --filters Name=replication-task-arn,Values="$ReplicationTaskArn" --query 'ReplicationTasks[].Status' --output text`
 echo $TASK_STATUS
 if [ $TASK_STATUS = "ready" ]
 then
   echo 'BREAK'
   break
  fi
 sleep 5
done

aws dms start-replication-task \
--replication-task-arn $ReplicationTaskArn \
--start-replication-task-type start-replication
