This document describes how to build datalake on S3 from multiple data sources and ETL with glue

# Create Key Pair
1. Services -> EC2 선택
2. 화면 좌측의 "Key Pairs" Click
3. "Create key pair" Click
4. Name : id_rsa_main 입력 후 "Create key pair" click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/1.png) </kbd>

5. 자동으로 pem key가 다운로드 됩니다. 해당 파일은 EC2 접속을 할 수 있는 중요한 key 파일입니다. 파일 퍼미션을 400으로 변경 후, 안전한 곳에 파일을 저장합니다.

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/2.png) </kbd>


# Create VPC & Test Environment

이 과정에서는 OnPREM 환경에 해당하는 OnPREM VPC와 AWS 환경에 해당하는 AWSDC VPC를 CloudFormation을 이용하여 생성합니다. 

```
참고 -------------------------------------------------

OnPREM-VPC 10.100.0.0/16
OnPREM-PUBLIC-SUBNET1 10.100.1.0/24
OnPREM-PUBLIC-SUBNET2 10.100.2.0/24
OnPREM-PRIVATE-SUBNET1 10.100.101.0/24
OnPREM-PRIVATE-SUBNET2 10.100.102.0/24
```

  
1. Services -> CloudFormation 선택
2. OnPREM VPC 생성 을 위해 "Create Stack" Click
3. "Amazon S3 URL" 부분에 
https://migration-hol-kiwony.s3.ap-northeast-2.amazonaws.com/OnPREM3.yml 를 입력하고 "Next" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/3.png) </kbd>

4. Stack name: "OnPREM"을 입력<br>
    KeyName : id_rsa_main을 선택<br>
    나머지는 Default로 두고 "Next" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/4.png) </kbd>

5. "Configure stack options"은 Default로 두고 "Next" Click
6. "Review" Page에서 "I acknowledge that AWS CloudFormation might create IAM resources with custom names."을 Check하고, "Create Stack"을 Click하여 CloudFormation 실행 

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/5.png) </kbd>

7. OnPREM Stack과 AWSDC Stack이 생성 완료 되는 것을 확인 (5~10분)

8. Stack이 완료되면 OnPREM Stack Outputs Tab의 내용 중 OraclePrivateIP, TomcatPublicIP, WindowsPublicIP를 복사해둡니다. (IP로 필터링하면 EC2 IP만 아래처럼 확인 가능합니다.)

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/6.png) </kbd>



# Create Datalake S3 bucket
1. Services -> s3 선택

2. "Create Bucket" Click

3.
```
Bucket Name : oracle-to-datalake-[USERNAME]
Region : Asia Pacific(Seoul)
```

**Example** : `oracle-to-datalake-kiwony`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/7.png) </kbd>

4. Click "Create"

# Create Query Result S3 bucket
1. Services -> s3 선택

2. "Create Bucket" Click

3.
```
Bucket Name : lgcns-query-result-[USERNAME]
Region : Asia Pacific(Seoul)
```

**Example** : `lgcns-query-result-kiwony`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/7.png) </kbd>

4. Click "Create"


# Create IAM Policy & Role

1. Services -> IAM

2. "Policies" Click

3. "Create Policy" Click

4. "JSON" Click

**Policy** : `prod.dms.s3.access.policy`

***Please replace s3 bucket name as yours***

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:ListJobs",
                "s3:CreateJob",
                "s3:HeadBucket"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::oracle-to-datalake-kiwony*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::oracle-to-datalake-kiwony*"
        }
    ]
}

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::oracle-to-datalake-kiwony*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::oracle-to-datalake-kiwony*"
            ]
        }
    ]
}
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/8.png) </kbd>

5. "Review policy" Click

6.  Name : prod.dms.s3.access.policy

7. "Create policy" Click

### Create Role

**Role** : `prod.dms.s3.access.role`
**Attach Policy** : `prod.dms.s3.access.policy`

1. Services -> IAM

2. "Roles" Click

3. "Create role" Click

4. 
```
Select type of trusted entity : AWS service
Choose a use case : DMS
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/9.png) </kbd>


5. "Next: Permissions" Click

6. Attach the created policy - `prod.dms.s3.access.policy`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/10.png) </kbd>

7.
`Role Name : prod.dms.s3.access.role`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/11.png) </kbd>

8. "Create role" click

# DMS Pre-requirement for Oracle

이 과정에서는 SQL Developer를 이용하여 Source OnPREM Oracle에서 Migration을 위한 선행 작업을 수행합니다. 
이 선행 작업은 DMS를 이용하여 S3 Datalake로 Data를 이관하는데 필요합니다. 

1. OnPREM stack Outputs의 WindowsPublicIP를 확인합니다.

2. RDP Client(mstsc.exe)를 실행하고 Windows Server에 접속

3. User name : administrator 

4. Password : cm4&gFxSBN@E5AWW)gL@@wTJ=N(IoToo   <= 공백이 없도록 주의하세요!!

5. “Shutdown Event Tracker” 경고창이 뜰 경우 “Cancel”을 누릅니다.

6.	Windows Server 화면 아래, MySQL Workbench 메뉴 옆의 SQL Developer 실행 

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/12.png) </kbd>

7.	OnPREM-ORACLE을 선택 후 "Connect"

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/14.png) </kbd>

8.	OnPREM-ORACLE 선행 작업 수행

```
a.	“Connect” Click 하여 접속(다시 sys password를 물어볼 경우 Octank#1234 입력)
b.	Worksheet에서 다음의 선행작업을 수행
c.	바탕화면의 Query.txt에서 “2. SQL Developer를 이용하여 OnPREM Oracle 선행 작업” 부분을 복사
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/15.png) </kbd>

9. 한 줄씩 Query를 수행 (실행하려는 Statement에 마우스 커서를 두고, 아래 화면의 맨 좌측 초록색 화살표를 클릭하면 Query 실행)
```
create user dms_user identified by Octank#1234 default tablespace users temporary tablespace temp quota unlimited on users;
grant connect, resource to dms_user;
grant EXECUTE ON dbms_logmnr to dms_user;
```
<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/16.png) </kbd>

10. 다음의 Grant Statement들을 Drag하여 모두 선택 후 Query 실행(SQL Developer의 Bug때문에 Grant 문장들을 3번 정도 실행합니다.)

```
GRANT SELECT ANY TRANSACTION to dms_user;
GRANT SELECT on V_$ARCHIVED_LOG to dms_user;
GRANT SELECT on V_$LOG to dms_user;
GRANT SELECT on V_$LOGFILE to dms_user;
GRANT SELECT on V_$DATABASE to dms_user;
GRANT SELECT on V_$THREAD to dms_user;
GRANT SELECT on V_$PARAMETER to dms_user;
GRANT SELECT on V_$NLS_PARAMETERS to dms_user;
GRANT SELECT on V_$TIMEZONE_NAMES to dms_user;
GRANT SELECT on V_$TRANSACTION to dms_user;
GRANT SELECT on ALL_INDEXES to dms_user;
GRANT SELECT on ALL_OBJECTS to dms_user;
GRANT SELECT on DBA_OBJECTS to dms_user; 
GRANT SELECT on ALL_TABLES to dms_user;
GRANT SELECT on ALL_USERS to dms_user;
GRANT SELECT on ALL_CATALOG to dms_user;
GRANT SELECT on ALL_CONSTRAINTS to dms_user;
GRANT SELECT on ALL_CONS_COLUMNS to dms_user;
GRANT SELECT on ALL_TAB_COLS to dms_user;
GRANT SELECT on ALL_IND_COLUMNS to dms_user;
GRANT SELECT on ALL_LOG_GROUPS to dms_user;
GRANT SELECT on SYS.DBA_REGISTRY to dms_user;
GRANT SELECT on SYS.OBJ$ to dms_user;
GRANT SELECT on DBA_TABLESPACES to dms_user;
GRANT SELECT on ALL_TAB_PARTITIONS to dms_user;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS to dms_user;
GRANT SELECT on V_$LOGMNR_LOGS to dms_user;
GRANT SELECT on V_$LOGMNR_CONTENTS to dms_user;
GRANT SELECT on ALL_VIEWS to dms_user;
GRANT SELECT ANY TABLE to dms_user;
GRANT ALTER ANY TABLE to dms_user;
GRANT create any directory to dms_user;
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/17.png) </kbd>

11. 다음의 Query들을 한줄씩 수행합니다. 

```
SELECT name, value, description FROM v$parameter WHERE name = 'compatible';

ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;

ALTER TABLE SWINGBENCH2.ORDERS ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.CUSTOMERS ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.ADDRESSES ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.CARD_DETAILS ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.WAREHOUSES ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.ORDER_ITEMS ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.INVENTORIES ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.PRODUCT_INFORMATION ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.PRODUCT_DESCRIPTIONS ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
ALTER TABLE SWINGBENCH2.LOGON ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
ALTER TABLE SWINGBENCH2.ORDERENTRY_METADATA ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
```

**ORA-32588 Error 발생시 무시합니다.**




# Database Migration Service

## DMS 사용을 위한 Role 생성

1.	DMS에서 사용할 dms-vpc-role을 우선 생성합니다. 

```
a.	Service -> IAM으로 이동
b.	좌측 메뉴에서 Roles 클릭
c.	“Create role” 버튼 클릭
d.	Select type of trusted entity에서 DMS 선택 후 “Next: Permissions” 클릭
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/18.png) </kbd>

```
e.	Attach permissions policies에서 AmazonDMSVPCManagementRole선택 후 “Next: Tags” 클릭
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/19.png) </kbd>

```
f.	Add tags (optional)은 Skip하고 “Nex: Review” 버튼 클릭
g.	Review에서 Role name에 “dms-vpc-role” 입력 후 “Create role” 버튼 클릭. (만약 이미 해당 Role이 있다고 나올 경우 Cancel하고, 이후 Step을 진행합니다.
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/20.png) </kbd>

2. DMS에서 사용할 dms-cloudwatch-logs-role을 생성합니다. 

```
a.	Service -> IAM으로 이동
b.	좌측 메뉴에서 Roles 클릭
c.	“Create role” 버튼 클릭
d.	Select type of trusted entity에서 DMS 선택 후 “Next: Permissions” 클릭
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/21.png) </kbd>

```
e.	Attach permissions policies에서 AmazonDMSCloudWatchLogsRole선택 후 “Next: Tags” 클릭
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/22.png) </kbd>

```
f.	Add tags (optional)은 Skip하고 “Nex: Review” 버튼 클릭
g.	Review에서 Role name에 “dms-vpc-role” 입력 후 “Create role” 버튼 클릭. (만약 이미 해당 Role이 있다고 나올 경우 Cancel하고, 이후 Step을 진행합니다.
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/23.png) </kbd>

## Create Replication Instance

1. Services => Database Migration Service

2. "Replication Instances" Click

3. "Create replication Instance" Click

4. Put the values as following
```
Name : RI-OracleToAurora
Description : RI-OracleToAurora
Instance class : dms.c4.xlarge
Engine version : 3.4.0
Allocated storage : 50
VPC : OnPREM
Multi AZ : Uncheck
Publicly accessible : Uncheck
나머지 값들은 Default 사용 
```
<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/24.png) </kbd>

5. "Create" Click

<kbd> ![GitHub Logo](images/15.png) </kbd>

## Create Source Endpoint(Oracle)
1. Services => Database Migration Service

2. "Endpoints" Click

3. "Create endpoint" Click

4. Put the values as following

```
Endpoint type : Source endpoint
Endpoint identifier : OnPREM-ORACLE
Source engine : oracle
Server name : 10.100.1.101
Port : 1521
User name : dms_user
Password : Octank#1234
SID/Service name : salesdb
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/25.png) </kbd>

### Extra Connections attributes : includeOpForFullLoad=true;cdcInsertsOnly=true

## Create Target Endpoint(S3)
1. Services => Database Migration Service

2. "Endpoints" Click

3. "Create endpoint" Click

4. Put the values as following

```
Endpoint type : Target endpoint
Endpoint identifier : S3-oracle-to-datalake-kiwony
Source engine : S3
Service access role ARN : arn:aws:iam::273175578093:role/prod.dms.s3.access.role
Bucket Name : oracle-to-datalake-kiwony
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/26.png) </kbd>

## Test Connection between Source Endpoint and Replication Instance

1. Services => Database Migration Service

2. "Endpoints" Click

3. "Check" onprem-oracle

4. Actions => "Test connection"

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/27.png) </kbd>

5. "Run Test" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/28.png) </kbd>


## Test Connection between Target Endpoint and Replication Instance

1. Services => Database Migration Service

2. "Endpoints" Click

3. "Check" s3-oracle-to-datalake-kiwony

4. Actions => "Test connection"

5. "Run Test" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/29.png) </kbd>


## Create Migration Task
1. Services => Database Migration Service

2. "Database migration tasks" Click

3. "Create task" Click

```
Task Identifier : OnPREM-Oracle-To-S3-oracle-to-datalake-kiwony
Replication Instance : ri-oracletos3datalake
Source database endpoint : onprem-oracle
Target database endpoint : s3-oracle-to-datalake-kiwony
Migration type : Migrate existing data
Enable CloudWatch logs : Check
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/30.png) </kbd>


```
Table mapping에서 아래처럼 입력
Editing mode – Guided UI 
Selection rules : “Add new selection rule” Click 후 아래처럼 입력
Schema : Enter a schema
Schema name: SWINGBENCH2
Table name : %
Action : Include
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/31.png) </kbd>

4. "Create task" Click

## Check Table Statistics

1. Services => Database Migration Service

2. "Database migration tasks" Click

3. "onprem-oracle-to-s3-oracle-to-datalake-kiwony" Click

4. "Table statistics" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/32.png) </kbd>

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/33.png) </kbd>


## Check S3 Bucket

1. Services => S3

2. "oracle-to-datalake-kiwony" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/34.png) </kbd>

3. "SWINGBENCH2" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/35.png) </kbd>

4. "ORDERS" Click

5. "LOAD00000001.csv" Click and download & Open

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/36.png) </kbd>


# Glue & Athena

## Create Database

1. Services => Glue

2. "Databases" Click

3. "Add database" Click
```
Database name : lgcns-soe
```

4. "Create" Click

## Create Tables using Cralwer

1. "Tables" Click

2. "Add tables" Click

3. "Add tables using a crawler" Click

4. Add information about your crawler
```
Cralwer Name : lgcns-soe-crawloer01
```

5. Specify crawler source type
```
Cralwer source type : Data stores
```

6. Add a data store
```
Choose a data store : S3
Crawl data in : Specified path in my account

Include Path : s3://oracle-to-datalake-kiwony/SWINGBENCH2/ORDERS
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/37.png) </kbd>

7. Add another data store

```
Add another data store : no
```

8. Choose an IAM role
```
Create an IAM role
AWSGlueServiceRole-GlueAdmin2
```

9. Create a schedule for this crawler
```
Run on demand
```

10. Configure the crawler's output
```
Database : lgcns-soe
```

 11. "Finish" Click

## Run Crawler

1. Check "lgcns-soe-crawloer01"

2. "Run crawler" Click

3. "Tables added : 1"

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/38.png) </kbd>


## Check Created Table Metadata
1. "Tables" Click

2. "orders" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/39.png) </kbd>

3. Check Metadata

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/40.png) </kbd>


## Athena Query Result Bucket Setup

1. Services => Athena

2. "Settings" Click

3. Query result location : `s3://lgcns-query-result-kiwony`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/41.png) </kbd>

4. "Save" Click


## Check data count of orders table in Oracle 
1. Services => EC2

2. "OnPREM-OracleServer" Check

3. "Connect" Click

4. Choose "Session Manager" and Click "Connect"

5. Executes following commands

```
sh-4.2$ sudo su -
Last login: Wed Aug  5 08:48:47 EDT 2020 on pts/0
root@oracle11g:/root# su - oracle
Last login: Wed Aug  5 08:48:47 EDT 2020 on pts/0
oracle@oracle11g:/home/oracle> sqlplus swingbench2

SQL*Plus: Release 11.2.0.4.0 Production on Wed Aug 5 09:16:57 2020

Copyright (c) 1982, 2013, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.4.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options

SQL> select /*+ parallel (a 16) */ count(*) from orders a;

  COUNT(*)
----------
   1429790
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/43.png) </kbd>

## Check Migration data count of orders table in DMS
1. Services => DMS

2. "Database Migration tasks" Click

3. "onprem-oracle-to-s3-oracle-to-datalake-kiwony" Click

4. "Table statistics" Click

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/44.png) </kbd>

## Query on orders in S3

1. Run query on Query tab
`SELECT * FROM "lgcns-soe"."orders" limit 10;`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/42.png) </kbd>

2. Run count query on Query tab
`SELECT count(*) FROM "lgcns-soe"."orders";`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/45.png) </kbd>

3. Run Following Queries for test
```
select col2 as "ORDER_MODE", count(*) as "COUNT" from "lgcns-soe"."orders" group by col2 order by 1;
select col1 as "ORDER_DATE", col2 as "ORDER_MODE", count(*) as "COUNT" from "lgcns-soe"."orders" group by col1, col2 order by 1
select col13 as "CUSTOMER_CLASS", count(*) as "COUNT" from "lgcns-soe"."orders" group by col13 order by 2 desc;
```

## Create View from Query

1. Execute Query

`select col1 as "ORDER_DATE", col2 as "ORDER_MODE", count(*) from "lgcns-soe"."orders" group by col1, col2 order by 1;`

2. "Create" Click

3. "Create View From Query" Click

4. Name : `DATE-MODE-COUNT`
CREATE OR REPLACE VIEW "DATE-MODE-COUNT" AS
select col1 as "ORDER_DATE", col2 as "ORDER_MODE", count(*) as "COUNT" from "lgcns-soe"."orders" group by col1, col2 order by 1;


```
select col13 as "CUSTOMER_CLASS", count(*) as "COUNT" from "lgcns-soe"."orders" group by col13 order by 2 desc;
Create View : `SellAmountByCustomerClass`
```


## Create QuickSight Account
1. Services => QuickSight

2. Sign up for Quicksight

3. Select "Standard"
   
4. "Continue" Click

5. "Select a region." : `Asia Pacific(Seoul)`

6. Create your QuickSight account

**개인별로 Unique한 Account Name, Email을 넣으세요**
```
Select a region : Asia Pacific(Seoul)
QuickSight account Name : kiwony20200805
Notification email address : kiwony@amazon.com
Select Amazon S3
```

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/46.png) </kbd>

7. Select all buckets

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/47.png) </kbd>

8. "Finish" Click

9. "Go to Amazon QuickSight" Click


## Create QuickSight DashBoard
1. "New Analysis" Click

2. "New dataset" Click

3. "Athena" Click

4. Data source name : `soe-orders`

<kbd> ![GitHub Logo](oracle-to-s3-datalake-images/48.png) </kbd>













