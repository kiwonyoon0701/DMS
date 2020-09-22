# Data Transfer from S3 to Oracle

## Create S3 Bucket and Place Source Data

```
root@ip-10-100-1-108:/data/2018# head -n1 bike2018.csv
970,"2018-01-01 13:50:57.4340","2018-01-01 14:07:08.1860",72,"W 52 St & 11 Ave",40.76727216,-73.99392888,505,"6 Ave & W 33 St",40.74901271,-73.98848395,31956,"Subscriber",1992,1

root@ip-10-100-1-108:/data/2018# ls -alh bike2018.csv
-rw-r--r-- 1 root root 3.2G Sep  1 14:07 bike2018.csv

root@ip-10-100-1-108:/data/2018# wc -l bike2018.csv
17548339 bike2018.csv


root@ip-10-100-1-108:/data/2018# aws s3 mb s3://bikedata-kiwony/
root@ip-10-100-1-108:/data/2018# aws s3 cp bike2018.csv s3://bikedata-kiwony/schemaname/tablename/

//root@ip-10-100-1-108:/data/2018# aws s3 cp bike2018.csv s3://bikedata-kiwony/2018/

```

## Create IAM Policy and Role to use DMS on S3

bikedata-policy.json

```
root@ip-10-100-1-108:/data/2018# cat bikedata-policy.json
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
            "Resource": "arn:aws:s3:::bikedata-kiwony*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::bikedata-kiwony*"
        }
    ]
}

```

aws iam create-policy

```
root@ip-10-100-1-108:/data/2018# aws iam create-policy --policy-name bikedata-policy --policy-document file://bikedata-policy.json
{
    "Policy": {
        "PolicyName": "bikedata-policy",
        "PolicyId": "ANPAZVQXJIKFDFUV7C4DQ",
        "Arn": "arn:aws:iam::664695030410:policy/bikedata-policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2020-09-01T14:18:56Z",
        "UpdateDate": "2020-09-01T14:18:56Z"
    }
}


```

bikedata-role-trust-policy.json

```
root@ip-10-100-1-108:/data/2018# cat bikedata-role-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::664695030410:root" },
        "Action": "sts:AssumeRole"
    }
}

```

aws iam create-role

```
root@ip-10-100-1-108:/data/2018# aws iam create-role --role-name bikedata-role --assume-role-policy-document file://bikedata-role-trust-policy.json
{
    "Role": {
        "Path": "/",
        "RoleName": "bikedata-role",
        "RoleId": "AROAZVQXJIKFFQPFCZYVX",
        "Arn": "arn:aws:iam::664695030410:role/bikedata-role",
        "CreateDate": "2020-09-01T14:30:22Z",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::664695030410:root"
                },
                "Action": "sts:AssumeRole"
            }
        }
    }
}

```

```
root@ip-10-100-1-108:/data/2018# aws iam put-role-policy --role-name bikedata-role --policy-name bikedata-policy --policy-document file://bikedata-policy.json

root@ip-10-100-1-108:/data/2018# aws iam get-role-policy --role-name bikedata-role --policy-name bikedata-policy
{
    "RoleName": "bikedata-role",
    "PolicyName": "bikedata-policy",
    "PolicyDocument": {
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
                "Resource": "arn:aws:s3:::bikedata-kiwony*"
            },
            {
                "Sid": "VisualEditor2",
                "Effect": "Allow",
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::bikedata-kiwony*"
            }
        ]
    }
}


root@ip-10-100-1-108:/data/2018# aws iam get-role --role-name bikedata-role --query 'Role.Arn'
"arn:aws:iam::664695030410:role/bikedata-role"


```

# Create Oracle Instance and Get connection Info

Do this by yourself

# Create Replication instance

## Create replication Instance

aws dms create-replication-instance \
--replication-instance-identifier RI-Default-VPC \
--replication-instance-class dms.c4.xlarge \
--no-multi-az \
--engine-version "3.4.0" \
--no-publicly-accessible

"arn:aws:dms:ap-northeast-2:664695030410:rep:RQE3BJ32ZHI52NY42YCTKLBXFCJI3U2YT3FLY2Q"

## Create Source Endpoint - S3 & Test Connection

```
{
    "TableCount": "1",
    "Tables": [
        {
            "TableName": "address",
            "TablePath": "address/zipcode/",
            "TableOwner": "zipcode",
            "TableColumns": [
                {
                    "ColumnName": "tripduration",
                    "ColumnType": "INT8"
                },
                {
                    "ColumnName": "startime",
                    "ColumnType": "STRING",
                    "ColumnLength": "20"
                },
                  {
                    "ColumnName": "stoptime",
                    "ColumnType": "STRING",
                    "ColumnLength": "20"
                },
                {
                    "ColumnName": "start_station",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "start_station_name",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
            	{
                    "ColumnName": "start_latitude",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "start_longtitude",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "end_station",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "end_station_name",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
            	{
                    "ColumnName": "end_latitude",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "end_longtitude",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                 {
                    "ColumnName": "bikeid",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
                {
                    "ColumnName": "usertype",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                },
            	{
                    "ColumnName": "birthyear",
                    "ColumnType": "STRING",
                    "ColumnLength": "50",
                    "ColumnNullable": "true"
                },
                {
                    "ColumnName": "gender",
                    "ColumnType": "STRING",
                    "ColumnLength": "50"
                }
            ],
            "TableColumnsTotal": "15"
        }
    ]
}
```

<kbd> ![GitHub Logo](images/1.png) </kbd>

aws dms create-endpoint \
--endpoint-identifier bikedata-s3 \
--endpoint-type source \
--engine-name s3 \
--s3-settings ServiceAccessRoleArn=arn:aws:iam::664695030410:role/bikedata-role,BucketName=bikedata-kiwony

aws dms test-connection \
--replication-instance-arn arn:aws:dms:ap-northeast-2:664695030410:rep:6PYMAMWLUC2DYG7TJOP7TKFOEPHMBY2HB5JLR7I \
--endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:YARIYJU3BMOUG576NEFJPPICMMS22F2WWCOOUF

## Create Target Endpoint & Test Connection

aws dms create-endpoint \
--endpoint-identifier target-aurora01 \
--endpoint-type target \
--engine-name aurora \
--username admin \
--password <PASSWORD> \
--server-name cluster01.cluster-cf89zyffo8dr.ap-northeast-2.rds.amazonaws.com \
--port 3306

aws dms test-connection \
--replication-instance-arn arn:aws:dms:ap-northeast-2:664695030410:rep:6PYMAMWLUC2DYG7TJOP7TKFOEPHMBY2HB5JLR7I \
--endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:YARIYJU3BMOUG576NEFJPPICMMS22F2WWCOOUF

# DMS Task

aws dms create-replication-task \
--replication-task-identifier mig01 \
--source-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:YARIYJU3BMOUG576NEFJPPICMMS22F2WWCOOUFQ \
--target-endpoint-arn arn:aws:dms:ap-northeast-2:664695030410:endpoint:EVUY4OXIPEMSH6FVQ6GP6Z5RDXRBX3NSWDM7ITQ \
--replication-instance-arn arn:aws:dms:ap-northeast-2:664695030410:rep:6PYMAMWLUC2DYG7TJOP7TKFOEPHMBY2HB5JLR7I \
--migration-type full-load \
--replication-task-settings file://replication-task.json \
--table-mappings file://table-mapping.json
