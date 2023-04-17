

## Appendix-1 - EC2 Instance에 Session Manager를 사용하여 Terminal 접속하는 방법

1. EC2 Console로 이동([link](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#Instances:instanceState=running))



2. 접속하고자 하는 EC2 Instance 앞의 CheckBox를 선택하고, 화면 상단 중앙에 `Connect` Click

![image-20230223163729990](../../../../../../static/using-dms/image-20230223163729990.png)



3. `Session Manager` Tab에서 `Connect` Click

![image-20230223163557863](../../../../../../static/using-dms/image-20230223163557863.png)



4. 다음의 Command를 수행하여 `oracle` user로 Switch 합니다.

```
sudo su -
su - oracle


Ternimal Output Example>>>
sh-4.2$ sudo su -
[root@ip-20-0-134-49 ~]# su - oracle
Last login: Mon Feb 20 05:13:20 UTC 2023
[oracle@ip-20-0-134-49 ~]$

```

![image-20230223163843135](../../../../../../static/using-dms/image-20230223163843135.png)



---

## Appendix-2 - Terminal에서 AWS Credential 설정 방법

1. `Access AWS Account` Page에서 export로 시작하는 3 Line을 복사합니다. (Copied! 버튼을 누르면 자동으로 복사 됩니다.)

![image-20230223164446837](../../../../../../static/using-dms/image-20230223164446837.png)

2. Terminal에 붙여 넣기 합니다. `aws sts get-caller-identity`를 실행하여 환경 설정이 잘 되었는지 확인합니다.

```
[oracle@ip-20-0-134-49 ~]$ export AWS_ACCESS_KEY_ID="ASIAU243AFXXXXXXXXXXXXX"
[oracle@ip-20-0-134-49 ~]$ export AWS_SECRET_ACCESS_KEY="KnXEs36z8TP/XXXXXXXXXXXXXXXXXXXXXXX"
[oracle@ip-20-0-134-49 ~]$ export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEFAaCXVzLWVhc3QtMSJIMEYCIQC19ohX//mObRwyrj8XxhzTJLr6CfYYhbpcC0YPQW/YFgIhAM7YpRTC6otkGjVlTpp7uReg7lFc5CcS9X7XqOk8V7efKqICC////wEQARoMMzMyNjQ4MTYzNjgyIgzMp59+11pLU5520LIq9gFhstv2YQqAEaQNbqESVdgDwhwI2gbvzMqs+hBbmkqdJSKYw1aHhYohfa5kBBfY/b+Dt4LpjfN6MSptdbayy46HVR1fvxhmhDjQ8dsHiniqcQCKQcP4Yhi2dx3SYlHMSOnqQZ0ikb7jIBgzgwiFthKEd5hnWyISHztT1JrC8iudis7bpxJHquvPxPqdRxn5qmil0uhh6mIUe2whbidv4RPY60+oHtEEXSxqT62NCt2UxtpT74G5ih8+6OLuWf8ZNEmltX+wa9ZxyTtRtbRoHWIqrSQtA1VPm4WHqTBDEgqA2bmAbN5ro8DR2Yregm2lPfMOyJ5j684wo6HcnwY6nAHmaNKErMt3YPWK0CWlgf8Iuwla/M/yjiTRQGtfI8Qow1v8mjTQKRa9M7ei49eAKP1+ja1YNEzicS+IhDgv0CnD1HgekoaEiKMHOBWftI1U1ys4nVvEzfiWCYERizWjnVnMCjV/kAIzVg9SmqJ5Jac6BdLzlbJFZ7j4df7WwlJjYcPFQHOKLfBRD3ziOBzJvXEGgDt2MTcxiiPiahs="
[oracle@ip-20-0-134-49 ~]$

[oracle@ip-20-0-134-49 ~]$ aws sts get-caller-identity
{
    "UserId": "AROAU243AFFRB5BAEW7GD:Participant",
    "Account": "332648XXXXXXX",
    "Arn": "arn:aws:sts::332648XXXXXXX:assumed-role/WSParticipantRole/Participant"
}
```







# S3 Bucket 생성

1. S3 Console로 이동합니다.([Link](https://s3.console.aws.amazon.com/s3/buckets?region=ap-northeast-2))



2. `Create bucket` Click



3. `rds-rmanbackup-<YOURNAME>-<date>` 을 입력하고 `Create bucket`  Click

![image-20230218215111175](images/image-20230218215111175.png)

---

# Source Database 사전 작업



### AWS Credential Setup

1. Workshop Studio Page에서 `AWS CLI credentials` 의 내용들을 copy

![image-20230218214707471](images/image-20230218214707471.png)



2. Session Manager Terminal에서 위에서 복사한 3가지 환경 변수를 Paste합니다. 그리고 권한을 확인합니다.

```
[oracle@ip-20-0-143-74 ~]$ export AWS_ACCESS_KEY_ID="ASIASSTFU4XXXXXXXX"
[oracle@ip-20-0-143-74 ~]$ export AWS_SECRET_ACCESS_KEY="LBePNMXXXXXXXXXXXXXXXXXXX"
[oracle@ip-20-0-143-74 ~]$ export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEN3//////////wEaCXVzLWVhc3QtMSJIMEYCIQCaurgqEub+2/bGKjYdaEltUZA7Lgwdk8zH9H9gYwnp5QIhAJR73gt1g4Ch7USw33oowdIUi4dDgYgcuqFOqHVVMXZwKpkCCHYQABoMMTc3MzgwNTgyNzI2IgxveTXyXpqQ0NtWR1sq9gFpiHXytbN4hwpp5vD0Xr4nSzHol5bdBV3c7nzgHUsO7SjK6XLFqwzTLYnMQLmC8/ZHeq77p9pvOIvc4NA9Furk7Wx+opUl5nCTfRQQKLinPddejhwf05dJzj7yF81E0o2M97a4g+o1ItcnX+fbvbItuiII85nYLX6Ar3ZpVDkbhRk14Dyhc0TP+jRRXXXXXXXXXXXXXXXXXXXXX

[oracle@ip-20-0-143-74 ~]$ aws sts get-caller-identity
{
    "UserId": "AROASSTFU4VDHN4AOP7VL:Participant",
    "Account": "177380XXXXXXXXXX",
    "Arn": "arn:aws:sts::177380XXXXXXXXXXXX:assumed-role/WSParticipantRole/Participant"
}
```







### Create Password File

1. EC2 Console로 이동합니다.([link](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#Instances:instanceState=running))



2. `OnPremDB` 앞의 CheckBox를 선택하고  화면 중앙 상단에 `Connect` Click

3. `Connect to instance` 화면에서 `Session Manager` Tab을 선택한 상태로 `Connect` Click



4. Terminal 에서 다음 command들을 수행하여 oracle user로 Switch

```
sudo su -
su - oracle

sh-4.2$ sudo su -
Last login: Sat Feb 18 12:06:41 UTC 2023 on pts/1
[root@ip-20-0-143-74 ~]# su - oracle
Last login: Sat Feb 18 12:06:43 UTC 2023 on pts/1
[oracle@ip-20-0-143-74 ~]$
[oracle@ip-20-0-143-74 ~]$ echo $ORACLE_HOME
/opt/oracle/product/19c/dbhome_1
[oracle@ip-20-0-143-74 ~]$ echo $ORACLE_SID
DEV
```



5. Password File을 생성 및 확인

```
[oracle@ip-20-0-143-74 ~]$ mv /opt/oracle/product/19c/dbhome_1/dbs/orapwDEV /opt/oracle/product/19c/dbhome_1/dbs/orapwDEV.org    

[oracle@ip-20-0-143-74 ~]$ $ORACLE_HOME/bin/orapwd file=$ORACLE_HOME/dbs/orapwDEV

Enter password for SYS:
welcome#12

[oracle@ip-20-0-143-74 ~]$ ls -r $ORACLE_HOME/dbs/orapwDEV
/opt/oracle/product/19c/dbhome_1/dbs/orapwDEV
```



6. init file 생성

```
[oracle@ip-20-0-143-74 ~]$ sqlplus / as sysdba

SQL> create pfile='/home/oracle/initDEV.ora' from spfile;

File created.

SQL> !ls /home/oracle/initDEV.ora
/home/oracle/initDEV.ora
```



7. AWS CLI 사용을 위한 환경 변수 설정

위에서 설명한 `AWS Credential Setup` Step을 보고 환경 변수를 설정합니다.



8. `aws s3 ls` 를 수행하여 위에서 생성한 Bucket을 확인합니다.

```
[oracle@ip-20-0-143-74 ~]$ aws s3 ls
2023-02-17 00:15:02 aws-rds-custom-oracle-177380582726-ap-northeast-2
2023-02-17 00:36:43 do-not-delete-rds-custom-177380582726-ap-northeast-2-82c032
2023-02-18 12:36:25 rds-rmanbackup-kiwony
```



9. 생성한 password file과 init file을 s3 bucket에 복사합니다.

```
[oracle@ip-20-0-143-74 ~]$ aws s3 cp ~/initDEV.ora s3://rds-rmanbackup-kiwony
upload: ./initDEV.ora to s3://rds-rmanbackup-kiwony/initDEV.ora

[oracle@ip-20-0-143-74 ~]$ aws s3 cp /opt/oracle/product/19c/dbhome_1/dbs/orapwDEV s3://rds-rmanbackup-kiwony
upload: ../../opt/oracle/product/19c/dbhome_1/dbs/orapwDEV to s3://rds-rmanbackup-kiwony/orapwDEV

[oracle@ip-20-0-143-74 ~]$ aws s3 ls rds-rmanbackup-kiwony
2023-02-18 12:53:12       1069 initDEV.ora
2023-02-18 12:54:07       6144 orapwDEV
```



---

### Target RDS Custom에 접속

1. EC2 Console로 이동합니다.([link](https://ap-northeast-2.console.aws.amazon.com/ec2/home?region=ap-northeast-2#Instances:instanceState=running))



2. RDS Custom for Oracle Instance 앞의 체크 박스를 선택하고 `Connect` Click



3. `Connect to instance` 화면에서 `Session Manager` Tab을 선택한 상태로 `Connect` Click



4. Terminal 에서 다음 command들을 수행하여 oracle user로 Switch

```
sudo su -
su - oracle

[ssm-user@ip-20-0-135-67 bin]$ sudo su -
Last login: Sat Feb 18 12:56:36 UTC 2023 on pts/0
[root@ip-20-0-135-67 ~]# su - oracle
Last login: Sat Feb 18 12:56:38 UTC 2023 on pts/0
-bash-4.2$
```



5. AWS CLI 사용을 위한 환경 변수 설정

위에서 설명한 `AWS Credential Setup` Step을 보고 환경 변수를 설정합니다.



6. Password file과 init file을 download 합니다.

```
-bash-4.2$ export AWS_ACCESS_KEY_ID="ASIASSTFUXXXXXXXXXXXXX"
-bash-4.2$ export AWS_SECRET_ACCESS_KEY="LBePNMimhF1Pk1CcXXXXXXXXXXXXXXXXXXXXXXXX"
-bash-4.2$ export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEN3//////////wEaCXVzLWVhc3QtMSJIMEYCIQCaurgqEub+2/bGKjYdaEltUZA7Lgwdk8zH9H9gYwnp5QIhAJR73gt1g4Ch7USw33oowdIUi4dDgYgcuqFOqHVVMXZwKpkCCHYQABoMMTc3MzgwNTgyNzI2IgxveTXyXpqQ0NtWR1sq9gFpiHXytbN4hwpp5vD0Xr4nSzHol5bdBV3c7nzgHUsO7SjK6XLFqwzTLYnMQLmC8/ZHeq77p9pvOIvc4NA9Furk7Wx+opUl5nCTfRQQKLinPddejhwf05dJzj7yF81E0o2M97a4g+o1ItcnX+fbvbItuiII85nYLX6Ar3ZpVDkbhRk14Dyhc0TP+jRRfkdZSlZpmOrcPLKjJ+XjRl+5gBXgk0GtnqgT200DFDuQL5QRqzGS5R5NO23KAYHEsmO2wW1R2HYDsskAC/UXZ5tXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

-bash-4.2$ aws s3 ls
2023-02-17 00:15:02 aws-rds-custom-oracle-177380582726-ap-northeast-2
2023-02-17 00:36:40 do-not-delete-rds-custom-177380582726-ap-northeast-2-82c032
2023-02-18 12:36:24 rds-rmanbackup-kiwony

-bash-4.2$ aws s3 ls rds-rmanbackup-kiwony
2023-02-18 12:53:12       1069 initDEV.ora
2023-02-18 12:54:07       6144 orapwDEV

-bash-4.2$ aws s3 cp s3://rds-rmanbackup-kiwony/initDEV.ora $ORACLE_HOME/dbs/
download: s3://rds-rmanbackup-kiwony/initDEV.ora to ../../u01/oracle/19.0.0/dbs/initDEV.ora
-bash-4.2$ ls $ORACLE_HOME/dbs/initDEV.ora
/u01/oracle/19.0.0/dbs/initDEV.ora

-bash-4.2$ aws s3 cp s3://rds-rmanbackup-kiwony/orapwDEV /rdsdbdata/config/
download: s3://rds-rmanbackup-kiwony/orapwDEV to ../../rdsdbdata/config/orapwDEV
-bash-4.2$ ls /rdsdbdata/config/orapwDEV
/rdsdbdata/config/orapwDEV

```



7. Create Symbolic Link

```
-bash-4.2$ ln -sf /rdsdbdata/config/orapwDEV /u01/oracle/19.0.0/dbs/orapwDEV
-bash-4.2$ ls -alrt /u01/oracle/19.0.0/dbs/orapwDEV
lrwxrwxrwx 1 oracle dba 26 Feb 18 13:14 /u01/oracle/19.0.0/dbs/orapwDEV -> /rdsdbdata/config/orapwDEV
```



---

### Source DB의 tnsnames.ora 수정

1. Session Manager를 사용하여`OnPremDB` EC2 Instance에 Terminal로 접속합니다.



2. TNS_ADMIN으로 이동합니다.

```
[oracle@ip-20-0-143-74 ~]$ cd $ORACLE_HOME/network/admin
[oracle@ip-20-0-143-74 admin]$ pwd
/opt/oracle/product/19c/dbhome_1/network/admin
[oracle@ip-20-0-143-74 admin]$ cp tnsnames.ora tnsnames.ora.bak
[oracle@ip-20-0-143-74 admin]$ ls tnsnames.ora*
tnsnames.ora  tnsnames.ora.bak
```



3. 다음의 내용을 적절하게 수정하여 tnsnames.ora에 넣어 줍니다.

```
DB_SOURCE =
(DESCRIPTION =
(ADDRESS = (PROTOCOL = TCP)(HOST = <source_instance_IP>)(PORT = 1521))
(CONNECT_DATA =
(SERVER = DEDICATED)
(SID = ORCL)
)
)
DB_TARGET =
(DESCRIPTION =
(ADDRESS = (PROTOCOL = TCP)(HOST = <RDS_Custom_instance_IP>)(PORT = 1521))
(CONNECT_DATA =
(SERVER = DEDICATED)
(SID = ORCL)
)
)
```

#### Example

```
DB_SOURCE =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.143.74)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)

DB_TARGET =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.135.67)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)
```



```
[oracle@ip-20-0-143-74 admin]$ cat tnsnames.ora
# tnsnames.ora Network Configuration File: /opt/oracle/product/19c/dbhome_1/network/admin/tnsnames.ora
# Generated by Oracle configuration tools.

DEV =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ip-20-0-143-74.ap-northeast-2.compute.internal)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEV)
    )
  )

LISTENER_ONPREMDB =
  (ADDRESS = (PROTOCOL = TCP)(HOST = ip-20-0-143-74.ap-northeast-2.compute.internal)(PORT = 1521))


LISTENER_DEV =
  (ADDRESS = (PROTOCOL = TCP)(HOST = ip-20-0-143-74.ap-northeast-2.compute.internal)(PORT = 1521))


RDS =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = rds-custom-dev.cwx7dmluiekk.ap-northeast-2.rds.amazonaws.com)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = DEV)
    )
  )

ONPREMDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = ip-20-0-143-74.ap-northeast-2.compute.internal)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ONPREMDB)
    )
  )

DB_SOURCE =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.143.74)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)

DB_TARGET =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.135.67)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)
```



4. tnsping 확인

```
[oracle@ip-20-0-143-74 admin]$ tnsping DB_TARGET
Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.135.67)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SID = DEV)))
OK (0 msec)


```



---

### Target RDS Custom 설정



1. initDEV.ora 수정

```
-bash-4.2$ cd $ORACLE_HOME/dbs
-bash-4.2$ pwd
/u01/oracle/19.0.0/dbs

-bash-4.2$ cat initDEV.ora
DEV.__data_transfer_cache_size=0
DEV.__db_cache_size=6039797760
DEV.__inmemory_ext_roarea=0
DEV.__inmemory_ext_rwarea=0
DEV.__java_pool_size=0
DEV.__large_pool_size=33554432
DEV.__oracle_base='/u01/app'#ORACLE_BASE set from environment
DEV.__pga_aggregate_target=4966055936
DEV.__sga_target=7449083904
DEV.__shared_io_pool_size=134217728
DEV.__shared_pool_size=1207959552
DEV.__streams_pool_size=0
DEV.__unified_pga_pool_size=0
*.archive_lag_target=300
*.audit_file_dest='/rdsdbdata/admin/DEV/adump'
*.compatible='19.0.0'
*.control_files='/rdsdbdata/db/DEV/controlfile/control-01.ctl'
*.db_block_checking='MEDIUM'
*.db_create_file_dest='/rdsdbdata/db'
*.db_name='DEV'
*.db_recovery_file_dest_size=1073741824
*.db_unique_name='DEV'
*.dbfips_140=FALSE
*.diagnostic_dest='/rdsdbdata/log'
*.filesystemio_options='setall'
*.heat_map='OFF'
*.job_queue_processes=50
*.local_listener='(address=(protocol=tcp)(host=)(port=8200))'
*.log_archive_dest_1='location="/rdsdbdata/db/DEV/arch/redolog", valid_for=(ALL_LOGFILES,ALL_ROLES)'
*.log_archive_format='-%s-%t-%r.arc'
*.max_string_size='STANDARD'
*.memory_max_target=12385852416
*.memory_target=12385852416
*.open_cursors=300
*.pga_aggregate_target=0
*.processes=1673
*.recyclebin='OFF'
*.sga_target=0
*.undo_tablespace='UNDOTBS1'
*.use_large_pages='FALSE'
*.DB_FILE_NAME_CONVERT='/opt/oracle/oradata/DEV/','/rdsdbdata/db/DEV/datafile/'
*.LOG_FILE_NAME_CONVERT='/opt/oracle/oradata/DEV/','/rdsdbdata/db/DEV/onlinelog/'

*.LOG_FILE_NAME_CONVERT='/opt/oracle/oradata/DEV/','/rdsdbdata/db/DEV/onlinelog/','/opt/oracle/fast_recovery_area/DEV/archivelog/','/rdsdbdata/db/DEV/onlinelog/'
/opt/oracle/fast_recovery_area/DEV/archivelog/
```

2. tnsnames.ora 수정

```
-bash-4.2$ cd $ORACLE_HOME/network/admin
-bash-4.2$ pwd
/u01/oracle/19.0.0/network/admin

-bash-4.2$ vi tnsnames.ora
-bash-4.2$ cat tnsnames.ora
DB_SOURCE =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.143.74)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)

DB_TARGET =
        (DESCRIPTION =
                (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.135.67)(PORT = 1521))
                (CONNECT_DATA =
                (SERVER = DEDICATED)
                (SID = DEV)
        )
)


-bash-4.2$ tnsping DB_SOURCE
...
Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS = (PROTOCOL = TCP)(HOST = 20.0.143.74)(PORT = 1521)) (CONNECT_DATA = (SERVER = DEDICATED) (SID = DEV)))
OK (0 msec)
```



3. Pause Amazon RDS Custom automation(최신 버전 aws cli update 필요)

```
as root user>> 

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```



```
aws rds modify-db-instance --db-instance-identifier rds-custom-dev --automation-mode all-paused --resume-full-automation-mode-minute 120 --region ap-northeast-2

=> 시간이 꽤 필요 해 보임(2차 테스트 시 5번 정도 실행했음)
```



4. Prepare RDS Custom monitoring and master user creation script(SKIP)

```
-bash-4.2$ sqlplus / as sysdba
SQL> shutdown immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.

SQL> STARTUP MOUNT EXCLUSIVE RESTRICT;
ORACLE instance started.

Total System Global Area 5.0063E+10 bytes
Fixed Size                 19527232 bytes
Variable Size            2.7783E+10 bytes
Database Buffers         2.2146E+10 bytes
Redo Buffers              114688000 bytes
Database mounted.
SQL> SP2-0223: No lines in SQL buffer.

SQL> DROP DATABASE;

Database dropped.

Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0
SQL> exit


```



5. Directory 생성

```
mkdir -p /rdsdbdata/db/DEV/datafile/
mkdir -p /rdsdbdata/db/DEV/onlinelog/
mkdir -p /rdsdbdata/db/DEV/controlfile/c
mkdir -p /rdsdbdata/admin/DEV/adump
mkdir -p /rdsdbdata/db/DEV/arch/redolog

-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/datafile/
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/onlinelog/
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/controlfile/c
-bash-4.2$ mkdir -p /rdsdbdata/admin/DEV/adump
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/arch/redolog
```





6. nomount로 DB 기동

```
-bash-4.2$ sqlplus / as sysdba
```



6. 

```
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/datafile/
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/onlinelog/
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/controlfile
-bash-4.2$ mkdir -p /rdsdbdata/admin/DEV/adump
-bash-4.2$ mkdir -p /rdsdbdata/db/DEV/arch/redolog
```



```
startup nomount pfile='/u01/oracle/19.0.0/dbs/initDEV.ora'
```



7. rman duplicate



```
rman target sys/welcome1@DB_SOURCE auxiliary sys/welcome1@DB_TARGET

duplicate database to 'DEV' from active database NOFILENAMECHECK;
```

```
 rman target sys/welcome1@prod_sync auxiliary sys/welcome1@proddg_dup
```



8. DB기동 확인

```
SQL> select name,open_mode from v$database;

NAME      OPEN_MODE
--------- --------------------
DEV       READ WRITE

```



9. Create the RDSADMIN and Master user and grant privileges

```
SQL>set echo on feedback on serverout on
SQL>@?/rdbms/admin/utlpwdmg.sql
SQL>ALTER PROFILE DEFAULT
LIMIT
FAILED_LOGIN_ATTEMPTS UNLIMITED
PASSWORD_LIFE_TIME UNLIMITED
PASSWORD_VERIFY_FUNCTION NULL;
```







5. Drop Dev Instance

```
LZimzgLg0K
```



```
/rdsdbdata/db/DEV/datafile/DEV/
```



```
/opt/oracle/fast_recovery_area/DEV/archivelog/
```





```

1. 현재 Role로는 DMS RI Instance 생성 권한이 없습니다. 권한을 추가하거나, Admin priv를 갖는 user를 만들어서 사용하거나 해야 할 것 같습니다.(아래 Screenshot)
2. EC2 Private IP를 고정하면 좋겠습니다. OnPREMDB는 가능할 것 같은데 RDS Custom용 EC2는 어려울 것 같기도 하네요.
3. EC2의 Private IP와  RDS의 Endpoint, admin password를 CF output에 보여주면 좀 더 편할것 같습니다.
4. DMS Workshop을 위해서는 RDS Custom DB에 SOE Schema 생성이 필요한데요, 미리 만들어둘지 Workshop에서 할지 의견 부탁 드립니다.
5.	rman duplicate를 RDS Custom DB명인 DEV로 OnPREMDB EC2에 dbca로 DB를 생성해서 작업을 하였습니다.(작업 편의성 및 데이터 복제 시간 줄이기 용도). OnPremDB EC2 생성 시 dbca가 돌아서 DEV도 하나 더 만들어지면 좋겠습니다. 
5-1. 5를 통해 DEV도 만들어지게 되면 2개의 Instance가 Running되는데, .bash_profile에 환경 변수를 설정할 수 있는 메뉴를 넣으면 좋을 것 같습니다. 
6. RDS Custom에서 drop database를 하기 위해서는, Health monitor에 의한 Auto Startup기능을 잠시 꺼야 하는데 AWS CLI가 구 버전이라서 해당 Command가 동작하지 않습니다. 현재 워크샵에서는 AWS CLI를 수동으로 Upgrade하는 스텝을 추가하긴 했습니다.


```

![image-20230219205218625](images/image-20230219205218625.png)







```

archived log for thread 1 with sequence 3 is already on disk as file /rdsdbdata/db/DEV/arch/redolog/-3-1-1129120259.arc
archived log for thread 1 with sequence 4 is already on disk as file /rdsdbdata/db/DEV/arch/redolog/-4-1-1129120259.arc
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-3-1-1129120259.arc thread=1 sequence=3
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-4-1-1129120259.arc thread=1 sequence=4
media recovery complete, elapsed time: 00:00:01
Finished recover at 18-FEB-23

contents of Memory Script:
{
   delete clone force archivelog all;
}
executing Memory Script

released channel: ORA_AUX_DISK_1
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=402 device type=DISK
deleted archived log
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-3-1-1129120259.arc RECID=1 STAMP=1129126763
deleted archived log
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-4-1-1129120259.arc RECID=2 STAMP=1129126764
Deleted 2 objects

Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes

contents of Memory Script:
{
   sql clone "alter system set  db_name =
 ''DEV'' comment=
 ''Reset to original value by RMAN'' scope=spfile";
   sql clone "alter system reset  db_unique_name scope=spfile";
}
executing Memory Script

sql statement: alter system set  db_name =  ''DEV'' comment= ''Reset to original value by RMAN'' scope=spfile

sql statement: alter system reset  db_unique_name scope=spfile
Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes
sql statement: CREATE CONTROLFILE REUSE SET DATABASE "DEV" RESETLOGS ARCHIVELOG
  MAXLOGFILES     16
  MAXLOGMEMBERS      3
  MAXDATAFILES      100
  MAXINSTANCES     8
  MAXLOGHISTORY      292
 LOGFILE
  GROUP     1 ( '/opt/oracle/oradata/DEV/redo01.log' ) SIZE 1 G  REUSE,
  GROUP     2 ( '/opt/oracle/oradata/DEV/redo02.log' ) SIZE 1 G  REUSE,
  GROUP     3 ( '/opt/oracle/oradata/DEV/redo03.log' ) SIZE 1 G  REUSE
 DATAFILE
  '/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/system01.dbf'
 CHARACTER SET AL32UTF8


contents of Memory Script:
{
   set newname for tempfile  1 to
 " /rdsdbdata/db/DEV/datafile/DEV/temp01.dbf";
   switch clone tempfile all;
   catalog clone datafilecopy  "/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/sysaux01.dbf",
 "/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/undotbs01.dbf",
 "/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/users01.dbf";
   switch clone datafile all;
}
executing Memory Script

executing command: SET NEWNAME

renamed tempfile 1 to  /rdsdbdata/db/DEV/datafile/DEV/temp01.dbf in control file

cataloged datafile copy
datafile copy file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/sysaux01.dbf RECID=1 STAMP=1129126794
cataloged datafile copy
datafile copy file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/undotbs01.dbf RECID=2 STAMP=1129126794
cataloged datafile copy
datafile copy file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/users01.dbf RECID=3 STAMP=1129126794

datafile 3 switched to datafile copy
input datafile copy RECID=1 STAMP=1129126794 file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/sysaux01.dbf
datafile 4 switched to datafile copy
input datafile copy RECID=2 STAMP=1129126794 file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/undotbs01.dbf
datafile 7 switched to datafile copy
input datafile copy RECID=3 STAMP=1129126794 file name=/u01/oracle/19.0.0/dbs/ /rdsdbdata/db/DEV/datafile/DEV/users01.dbf

contents of Memory Script:
{
   Alter clone database open resetlogs;
}
executing Memory Script

RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of Duplicate Db command at 02/18/2023 14:19:57
RMAN-05501: aborting duplication of target database
RMAN-03015: error occurred in stored script Memory Script
RMAN-06136: Oracle error from auxiliary database: ORA-00344: unable to re-create online log '/opt/oracle/oradata/DEV/redo01.log'
ORA-27040: file create error, unable to create file
Linux-x86_64 Error: 2: No such file or directory
Additional information: 1

```

```
export AWS_ACCESS_KEY_ID="ASIAXOBEAQ76L4ANJQ4X"
export AWS_SECRET_ACCESS_KEY="CRuJvh+hFIYOhqENpA8nS8YhrsFIcWQUmZ+o0aqo"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEPT//////////wEaCXVzLWVhc3QtMSJHMEUCICKUnQL1dBTlFApJx7ICpyvNsCyBwGlTVc/NaKxdrvi6AiEAy1+ln3h9IwNHNWAutecuDu7V6W0x2L6gDd4h8IBTA3AqogIIjf//////////ARABGgw1MTExNzY2NDA1MDgiDINE1FzzVWWkUT8Rsir2AaBMlNB7+HxjxgSfO310zwpLLJ38HvZ/O8VgryRY3MGgb7cSGs8BCsk5Dx0ZnLKTPBdc2JNYzWQGqHk3m+Lp5X3OewDorl7nB+UbQu4EpONpE/Wltxa+PsS6VTa4rfnj+DTLFqI/7eMyZzwfEdz/LFW8UrStiEIW8A9qC9zbzMejYTLA5WGtiRh5an5ukTPrPr09MepoZyXVv95xPxu+qCFpZF40ocHzU4axPi/dOqresgruuSI1xx2EfUkQjyzWuZ6EdvmrAD1FFharQSsUc1QDGd8Rp+HsKjftqEnB8OJ34t8SrZ/HFiHa+rDlYr7cFrkWCVIU6jCnmsifBjqdAUsjL++3rmAKwOsSZ0GB522Cu0aTZPhuem4nQCdNEh8nafBojJcwDxRsNWVfZAO6/kEHWmd7DJ/W64bdyJl2rPxxGd9QlHnGymqG/Q5R7xEy2pBmExrI0OYmRJsieR8Qw0unNDiT9Jf0HIGM25p3EkRtxf14Tw65o6Rmx40DijMmc86of0rvKQSbVn5hvn5ddRBnhDx5NjSN0QY1AwY="
```



```
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-00601: fatal error in recovery manager
RMAN-03004: fatal error during execution of command
RMAN-04006: error from auxiliary database: ORA-12537: TNS:connection closed
RMAN-03002: failure of Duplicate Db command at 02/19/2023 13:53:10
RMAN-05501: aborting duplication of target database
RMAN-03015: error occurred in stored script Memory Script
RMAN-06136: Oracle error from auxiliary database: ORA-00603: ORACLE server session terminated by fatal error
ORA-01092: ORACLE instance terminated. Disconnection forced
ORA-30012: undo tablespace 'UNDO_T1' does not exist or of wrong type
Process ID: 29182
Session ID: 1273 Serial number: 21072
```



rman duplicate success log

```

RMAN> duplicate database to 'DEV' from active database NOFILENAMECHECK;

Starting Duplicate Db at 19-FEB-23
using target database control file instead of recovery catalog
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=798 device type=DISK
current log archived

contents of Memory Script:
{
   sql clone "create spfile from memory";
}
executing Memory Script

sql statement: create spfile from memory

contents of Memory Script:
{
   shutdown clone immediate;
   startup clone nomount;
}
executing Memory Script

Oracle instance shut down

connected to auxiliary database (not started)
Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes

contents of Memory Script:
{
   sql clone "alter system set  db_name =
 ''DEV'' comment=
 ''Modified by RMAN duplicate'' scope=spfile";
   sql clone "alter system set  db_unique_name =
 ''DEV'' comment=
 ''Modified by RMAN duplicate'' scope=spfile";
   shutdown clone immediate;
   startup clone force nomount
   restore clone from service  'DB_SOURCE' primary controlfile;
   alter clone database mount;
}
executing Memory Script

sql statement: alter system set  db_name =  ''DEV'' comment= ''Modified by RMAN duplicate'' scope=spfile

sql statement: alter system set  db_unique_name =  ''DEV'' comment= ''Modified by RMAN duplicate'' scope=spfile

Oracle instance shut down

Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes

Starting restore at 19-FEB-23
allocated channel: ORA_AUX_DISK_1
channel ORA_AUX_DISK_1: SID=639 device type=DISK

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: restoring control file
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
output file name=/rdsdbdata/db/DEV/controlfile/control-01.ctl
Finished restore at 19-FEB-23

database mounted

contents of Memory Script:
{
   set newname for datafile  1 to
 "/rdsdbdata/db/DEV/datafile/system01.dbf";
   set newname for datafile  3 to
 "/rdsdbdata/db/DEV/datafile/sysaux01.dbf";
   set newname for datafile  4 to
 "/rdsdbdata/db/DEV/datafile/undotbs01.dbf";
   set newname for datafile  7 to
 "/rdsdbdata/db/DEV/datafile/users01.dbf";
   restore
   from  nonsparse   from service
 'DB_SOURCE'   clone database
   ;
   sql 'alter system archive log current';
}
executing Memory Script

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting restore at 19-FEB-23
using channel ORA_AUX_DISK_1

channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00001 to /rdsdbdata/db/DEV/datafile/system01.dbf
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00003 to /rdsdbdata/db/DEV/datafile/sysaux01.dbf
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00004 to /rdsdbdata/db/DEV/datafile/undotbs01.dbf
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting datafile backup set restore
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: specifying datafile(s) to restore from backup set
channel ORA_AUX_DISK_1: restoring datafile 00007 to /rdsdbdata/db/DEV/datafile/users01.dbf
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
Finished restore at 19-FEB-23

sql statement: alter system archive log current
current log archived

contents of Memory Script:
{
   restore clone force from service  'DB_SOURCE'
           archivelog from scn  2057530;
   switch clone datafile all;
}
executing Memory Script

Starting restore at 19-FEB-23
using channel ORA_AUX_DISK_1

channel ORA_AUX_DISK_1: starting archived log restore to default destination
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: restoring archived log
archived log thread=1 sequence=9
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_AUX_DISK_1: starting archived log restore to default destination
channel ORA_AUX_DISK_1: using network backup set from service DB_SOURCE
channel ORA_AUX_DISK_1: restoring archived log
archived log thread=1 sequence=10
channel ORA_AUX_DISK_1: restore complete, elapsed time: 00:00:01
Finished restore at 19-FEB-23

datafile 1 switched to datafile copy
input datafile copy RECID=5 STAMP=1129211824 file name=/rdsdbdata/db/DEV/datafile/system01.dbf
datafile 3 switched to datafile copy
input datafile copy RECID=6 STAMP=1129211824 file name=/rdsdbdata/db/DEV/datafile/sysaux01.dbf
datafile 4 switched to datafile copy
input datafile copy RECID=7 STAMP=1129211824 file name=/rdsdbdata/db/DEV/datafile/undotbs01.dbf
datafile 7 switched to datafile copy
input datafile copy RECID=8 STAMP=1129211824 file name=/rdsdbdata/db/DEV/datafile/users01.dbf

contents of Memory Script:
{
   set until scn  2057654;
   recover
   clone database
    delete archivelog
   ;
}
executing Memory Script

executing command: SET until clause

Starting recover at 19-FEB-23
using channel ORA_AUX_DISK_1

starting media recovery

archived log for thread 1 with sequence 9 is already on disk as file /rdsdbdata/db/DEV/arch/redolog/-9-1-1129204651.arc
archived log for thread 1 with sequence 10 is already on disk as file /rdsdbdata/db/DEV/arch/redolog/-10-1-1129204651.arc
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-9-1-1129204651.arc thread=1 sequence=9
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-10-1-1129204651.arc thread=1 sequence=10
media recovery complete, elapsed time: 00:00:00
Finished recover at 19-FEB-23

contents of Memory Script:
{
   delete clone force archivelog all;
}
executing Memory Script

released channel: ORA_AUX_DISK_1
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=596 device type=DISK
deleted archived log
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-9-1-1129204651.arc RECID=1 STAMP=1129211822
deleted archived log
archived log file name=/rdsdbdata/db/DEV/arch/redolog/-10-1-1129204651.arc RECID=2 STAMP=1129211823
Deleted 2 objects

Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes

contents of Memory Script:
{
   sql clone "alter system set  db_name =
 ''DEV'' comment=
 ''Reset to original value by RMAN'' scope=spfile";
   sql clone "alter system reset  db_unique_name scope=spfile";
}
executing Memory Script

sql statement: alter system set  db_name =  ''DEV'' comment= ''Reset to original value by RMAN'' scope=spfile

sql statement: alter system reset  db_unique_name scope=spfile
Oracle instance started

Total System Global Area   12415137200 bytes

Fixed Size                    12449200 bytes
Variable Size               6274678784 bytes
Database Buffers            6106906624 bytes
Redo Buffers                  21102592 bytes
sql statement: CREATE CONTROLFILE REUSE SET DATABASE "DEV" RESETLOGS ARCHIVELOG
  MAXLOGFILES     16
  MAXLOGMEMBERS      3
  MAXDATAFILES      100
  MAXINSTANCES     8
  MAXLOGHISTORY      292
 LOGFILE
  GROUP     1 ( '/rdsdbdata/db/DEV/onlinelog/redo01.log' ) SIZE 1 G  REUSE,
  GROUP     2 ( '/rdsdbdata/db/DEV/onlinelog/redo02.log' ) SIZE 1 G  REUSE,
  GROUP     3 ( '/rdsdbdata/db/DEV/onlinelog/redo03.log' ) SIZE 1 G  REUSE
 DATAFILE
  '/rdsdbdata/db/DEV/datafile/system01.dbf'
 CHARACTER SET AL32UTF8


contents of Memory Script:
{
   set newname for tempfile  1 to
 "/rdsdbdata/db/DEV/datafile/temp01.dbf";
   switch clone tempfile all;
   catalog clone datafilecopy  "/rdsdbdata/db/DEV/datafile/sysaux01.dbf",
 "/rdsdbdata/db/DEV/datafile/undotbs01.dbf",
 "/rdsdbdata/db/DEV/datafile/users01.dbf";
   switch clone datafile all;
}
executing Memory Script

executing command: SET NEWNAME

renamed tempfile 1 to /rdsdbdata/db/DEV/datafile/temp01.dbf in control file

cataloged datafile copy
datafile copy file name=/rdsdbdata/db/DEV/datafile/sysaux01.dbf RECID=1 STAMP=1129211852
cataloged datafile copy
datafile copy file name=/rdsdbdata/db/DEV/datafile/undotbs01.dbf RECID=2 STAMP=1129211852
cataloged datafile copy
datafile copy file name=/rdsdbdata/db/DEV/datafile/users01.dbf RECID=3 STAMP=1129211852

datafile 3 switched to datafile copy
input datafile copy RECID=1 STAMP=1129211852 file name=/rdsdbdata/db/DEV/datafile/sysaux01.dbf
datafile 4 switched to datafile copy
input datafile copy RECID=2 STAMP=1129211852 file name=/rdsdbdata/db/DEV/datafile/undotbs01.dbf
datafile 7 switched to datafile copy
input datafile copy RECID=3 STAMP=1129211852 file name=/rdsdbdata/db/DEV/datafile/users01.dbf

contents of Memory Script:
{
   Alter clone database open resetlogs;
}
executing Memory Script

database opened
Cannot remove created server parameter file
Finished Duplicate Db at 19-FEB-23
```







/opt/oracle/oradata/ONPREMDB/



```
[oracle@ip-20-0-143-74 ~]$ cat dbca.rsp
responseFileVersion=/oracle/assistants/rspfmt_dbca_response_schema_v12.2.0
gdbName=DEV
databaseConfigType=SI
policyManaged=false
createServerPool=false
force=false
createAsContainerDatabase=false
numberOfPDBs=0
templateName=/u01/app/oracle/product/19c/db_1/assistants/dbca/templates/General_Purpose.dbc
sysPassword=welcome1
systemPassword=welcome1
#emConfiguration=DBEXPRESS
#emExpressPort=5500
runCVUChecks=FALSE
omsPort=0
dvConfiguration=false
olsConfiguration=false
datafileJarLocation={ORACLE_HOME}/assistants/dbca/templates/
datafileDestination={ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/
recoveryAreaDestination={ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME}
storageType=FS
characterSet=AL32UTF8
nationalCharacterSet=AL16UTF16
registerWithDirService=false
listeners=LISTENER
variables=ORACLE_BASE_HOME=/u01/app/oracle/product/19c/db_1,ORACLE_BASE=/u01/app/oracle,PDB_NAME=,DB_NAME=DEV,ORACLE_HOME=/u01/app/oracle/product/19c/db_1
initParams=undo_tablespace=UNDOTBS1,db_block_size=8192BYTES,nls_language=AMERICAN,dispatchers=(PROTOCOL=TCP) (SERVICE=DEVXDB),diagnostic_dest={ORACLE_BASE},control_files=("{ORACLE_BASE}/oradata/{DB_UNIQUE_NAME}/control01.ctl", "{ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME}/control02.ctl"),remote_login_passwordfile=EXCLUSIVE,audit_file_dest={ORACLE_BASE}/admin/{DB_UNIQUE_NAME}/adump,processes=500,nls_territory=AMERICA,memory_target=4096MB,db_recovery_file_dest_size=50GB,open_cursors=300,log_archive_format=%t_%s_%r.dbf,compatible=19.0.0,db_name=DEV,db_recovery_file_dest={ORACLE_BASE}/fast_recovery_area/{DB_UNIQUE_NAME},audit_trail=db
sampleSchema=true
memoryPercentage=40
databaseType=MULTIPURPOSE
automaticMemoryManagement=false
totalMemory=0
redoLogFileSize=1024
```

```
dbca -silent -createDatabase -enableArchive true -responseFile ~/dbca.rsp
```





```
dbca -silent -createDatabase -responsefile $ORACLE_HOME/assistants/dbca/dbca.rsp

```



```
dbca -silent -deleteDatabase -sourceDB ORCL -sysDBAUserName sys -sysDBAPassword welcome1
```



```DELETE archivelog ALL;
DELETE archivelog ALL;
```

---

