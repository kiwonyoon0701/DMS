```
aws dms create-replication-task \
--replication-task-identifier orders001-task \
--source-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:RSICUHNZHGR3LEM774Q2HHPLIPDAG732YIRLEWQ \
--target-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:HUDRZ3O6WFZOJ3KFEIJLUY6J6F7NWXKJACIKGHQ \
--replication-instance-arn arn:aws:dms:ap-northeast-2:664695030410:rep:4UO7VATLK73OPWDGMFPW3R6SDKBCZH5OYRIDFEI \
--migration-type full-load \
--replication-task-settings file://orders001-task.json \
--table-mappings file://orders001.json

```
