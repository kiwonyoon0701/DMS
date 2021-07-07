### Source Oracle Preparation

**Supplemental logging & archivelog**

```
SELECT name, value, description FROM v$parameter WHERE name = 'compatible';
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
SELECT supplemental_log_data_min FROM v$database;
archive log list;

```

**Create dms_user and grant required privs**

```
CREATE USER DMS_USER IDENTIFIED BY Octank#1234 DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON USERS;
GRANT CONNECT, RESOURCE TO DMS_USER;
GRANT ALTER ANY TABLE to dms_user;
GRANT CREATE ANY DIRECTORY to dms_user;
GRANT CREATE SESSION TO dms_user;
GRANT EXECUTE ON DBMS_FILE_TRANSFER to dms_user;
GRANT EXECUTE on DBMS_LOGMNR to dms_user;
GRANT SELECT ANY TABLE to dms_user;
GRANT SELECT ANY TRANSACTION to dms_user;
GRANT SELECT on ALL_CATALOG to dms_user;
GRANT SELECT on ALL_CONS_COLUMNS to dms_user;
GRANT SELECT on ALL_CONSTRAINTS to dms_user;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS to dms_user;
GRANT SELECT on ALL_IND_COLUMNS to dms_user;
GRANT SELECT on ALL_INDEXES to dms_user;
GRANT SELECT on ALL_LOG_GROUPS to dms_user;
GRANT SELECT on ALL_OBJECTS to dms_user;
GRANT SELECT on ALL_TAB_COLS to dms_user;
GRANT SELECT on ALL_TABLES to dms_user;
GRANT SELECT on ALL_TAB_PARTITIONS to dms_user;
GRANT SELECT on ALL_USERS to dms_user;
GRANT SELECT on ALL_VIEWS to dms_user;
GRANT SELECT on DBA_OBJECTS to dms_user;
GRANT SELECT on DBA_TABLESPACES to dms_user;
GRANT SELECT on GV_$ARCHIVED_LOG to dms_user;
GRANT SELECT on GV_$DATABASE to dms_user;
GRANT SELECT on GV_$LOGFILE to dms_user;
GRANT SELECT on GV_$LOGMNR_CONTENTS to dms_user;
GRANT SELECT on GV_$LOGMNR_LOGS to dms_user;
GRANT SELECT on GV_$LOG to dms_user;
GRANT SELECT on GV_$NLS_PARAMETERS to dms_user;
GRANT SELECT on GV_$PARAMETER to dms_user;
GRANT SELECT on GV_$THREAD to dms_user;
GRANT SELECT on GV_$TIMEZONE_NAMES to dms_user;
GRANT SELECT on GV_$TRANSACTION to dms_user;
GRANT SELECT on SYS.DBA_REGISTRY to dms_user;
GRANT SELECT on SYS.OBJ$ to dms_user;
GRANT SELECT on V_$ARCHIVED_LOG to dms_user;
GRANT SELECT on V_$DATABASE to dms_user;
GRANT SELECT on V_$LOGFILE to dms_user;
GRANT SELECT on V_$LOGMNR_CONTENTS to dms_user;
GRANT SELECT on V_$LOGMNR_LOGS to dms_user;
GRANT SELECT on V_$LOG to dms_user;
GRANT SELECT on V_$NLS_PARAMETERS to dms_user;
GRANT SELECT on V_$PARAMETER to dms_user;
GRANT SELECT on V_$THREAD to dms_user;
GRANT SELECT on V_$TIMEZONE_NAMES to dms_user;
GRANT SELECT on V_$TRANSACTION to dms_user;
GRANT SELECT on v_$transportable_platform to dms_user;
GRANT SELECT ON DBA_FILE_GROUPS to dms_user;
GRANT EXECUTE ON SYS.DBMS_FILE_GROUP to DMS_user;
EXECUTE DBMS_FILE_GROUP.GRANT_SYSTEM_PRIVILEGE (DBMS_FILE_GROUP.MANAGE_ANY_FILE_GROUP, 'DMS_user', FALSE);


```

**Add supplemental log for tables**

```
SELECT 'ALTER TABLE '||owner||'.'||table_name||' ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;' as CMD from dba_tables where owner='&OWNER_NAME';


SELECT A.TABLE_NAME, A.CONSTRAINT_NAME, B.COLUMN_NAME, A.CONSTRAINT_TYPE, B.POSITION
FROM ALL_CONSTRAINTS  A, ALL_CONS_COLUMNS B
WHERE  A.CONSTRAINT_TYPE in ('P','U')
AND A.OWNER           = B.OWNER
AND A.CONSTRAINT_NAME = B.CONSTRAINT_NAME
AND A.OWNER= '&OWNER_NAME'
ORDER BY B.POSITION;

```

```

useLogMinerReader=N;useBfile=Y;asm_user=asmuser;asm_server=172.31.14.4:1522/+ASM;

```

```{
    "TargetMetadata": {
        "TargetSchema": "",
        "SupportLobs": true,
        "FullLobMode": false,
        "LobChunkSize": 0,
        "LimitedSizeLobMode": true,
        "LobMaxSize": 32,
        "InlineLobMaxSize": 0,
        "LoadMaxFileSize": 0,
        "ParallelLoadThreads": 0,
        "ParallelLoadBufferSize": 0,
        "BatchApplyEnabled": false,
        "TaskRecoveryTableEnabled": false,
        "ParallelLoadQueuesPerThread": 0,
        "ParallelApplyThreads": 0,
        "ParallelApplyBufferSize": 0,
        "ParallelApplyQueuesPerThread": 0
    },
    "FullLoadSettings": {
        "TargetTablePrepMode": "DROP_AND_CREATE",
        "CreatePkAfterFullLoad": false,
        "StopTaskCachedChangesApplied": false,
        "StopTaskCachedChangesNotApplied": false,
        "MaxFullLoadSubTasks": 8,
        "TransactionConsistencyTimeout": 600,
        "CommitRate": 10000
    },
    "Logging": {
        "EnableLogging": true,
        "LogComponents": [
            {
                "Id": "TRANSFORMATION",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "SOURCE_UNLOAD",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "IO",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "TARGET_LOAD",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "PERFORMANCE",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "SOURCE_CAPTURE",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "SORTER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "REST_SERVER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "VALIDATOR_EXT",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "TARGET_APPLY",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "TASK_MANAGER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "TABLES_MANAGER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "METADATA_MANAGER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "FILE_FACTORY",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "COMMON",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "ADDONS",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "DATA_STRUCTURE",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "COMMUNICATION",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            },
            {
                "Id": "FILE_TRANSFER",
                "Severity": "LOGGER_SEVERITY_DEFAULT"
            }
        ],
        "CloudWatchLogGroup": "dms-tasks-default-vpc-replication-instance",
        "CloudWatchLogStream": "dms-task-753R2R3QWWHZ5ZWIFUPD5ZUY5GSPNZ735IZP4KA"
    },
    "ControlTablesSettings": {
        "historyTimeslotInMinutes": 5,
        "ControlSchema": "",
        "HistoryTimeslotInMinutes": 5,
        "HistoryTableEnabled": false,
        "SuspendedTablesTableEnabled": false,
        "StatusTableEnabled": false,
        "FullLoadExceptionTableEnabled": false
    },
    "StreamBufferSettings": {
        "StreamBufferCount": 3,
        "StreamBufferSizeInMB": 8,
        "CtrlStreamBufferSizeInMB": 5
    },
    "ChangeProcessingDdlHandlingPolicy": {
        "HandleSourceTableDropped": true,
        "HandleSourceTableTruncated": true,
        "HandleSourceTableAltered": true
    },
    "ErrorBehavior": {
        "DataErrorPolicy": "LOG_ERROR",
        "DataTruncationErrorPolicy": "LOG_ERROR",
        "DataErrorEscalationPolicy": "SUSPEND_TABLE",
        "DataErrorEscalationCount": 0,
        "TableErrorPolicy": "SUSPEND_TABLE",
        "TableErrorEscalationPolicy": "STOP_TASK",
        "TableErrorEscalationCount": 0,
        "RecoverableErrorCount": -1,
        "RecoverableErrorInterval": 5,
        "RecoverableErrorThrottling": true,
        "RecoverableErrorThrottlingMax": 1800,
        "RecoverableErrorStopRetryAfterThrottlingMax": true,
        "ApplyErrorDeletePolicy": "IGNORE_RECORD",
        "ApplyErrorInsertPolicy": "LOG_ERROR",
        "ApplyErrorUpdatePolicy": "LOG_ERROR",
        "ApplyErrorEscalationPolicy": "LOG_ERROR",
        "ApplyErrorEscalationCount": 0,
        "ApplyErrorFailOnTruncationDdl": false,
        "FullLoadIgnoreConflicts": true,
        "FailOnTransactionConsistencyBreached": false,
        "FailOnNoTablesCaptured": true
    },
    "ChangeProcessingTuning": {
        "BatchApplyPreserveTransaction": true,
        "BatchApplyTimeoutMin": 1,
        "BatchApplyTimeoutMax": 30,
        "BatchApplyMemoryLimit": 500,
        "BatchSplitSize": 0,
        "MinTransactionSize": 1000,
        "CommitTimeout": 1,
        "MemoryLimitTotal": 1024,
        "MemoryKeepTime": 60,
        "StatementCacheSize": 50
    },
    "ValidationSettings": {
        "EnableValidation": true,
        "ValidationMode": "ROW_LEVEL",
        "ThreadCount": 5,
        "PartitionSize": 10000,
        "FailureMaxCount": 10000,
        "RecordFailureDelayInMinutes": 5,
        "RecordSuspendDelayInMinutes": 30,
        "MaxKeyColumnSize": 8096,
        "TableFailureMaxCount": 1000,
        "ValidationOnly": false,
        "HandleCollationDiff": false,
        "RecordFailureDelayLimitInMinutes": 0,
        "SkipLobColumns": false,
        "ValidationPartialLobSize": 0,
        "ValidationQueryCdcDelaySeconds": 0
    },
    "PostProcessingRules": null,
    "CharacterSetSettings": null,
    "LoopbackPreventionSettings": null,
    "BeforeImageSettings": null,
    "FailTaskWhenCleanTaskResourceFailed": false
}
```

```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "1",
            "rule-name": "1",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-target": "table",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "3",
            "rule-name": "3",
            "rule-target": "column",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%",
                "column-name": "%"
            },
            "rule-action": "convert-lowercase",
            "value": null,
            "old-value": null
        },
        {
            "rule-type": "selection",
            "rule-id": "4",
            "rule-name": "4",
            "object-locator": {
                "schema-name": "OSHOP",
                "table-name": "%"
            },
            "rule-action": "include",
            "filters": []
        }
    ]
}
```

**CDC configuration in ASM using asmuser**

```

connect sysasm
SQL> create user asmuser identified by asmuser;
User created.

SQL> grant sysasm to asmuser;
Grant succeeded.

useLogMinerReader=N;useBfile=Y;asm_user=asmuser;asm_server=172.31.14.4:1522/+ASM;

```
