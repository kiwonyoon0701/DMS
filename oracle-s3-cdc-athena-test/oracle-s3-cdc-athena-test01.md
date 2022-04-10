### Source Oracle Data를 S3로 CDC로 넘기고, Athena에서 이를 조회하는 것이 가능한지 검증

```
https://shared-kiwony.s3.ap-northeast-2.amazonaws.com/OnPREM4.yml
```



#### Oracle to S3

---

**S3 Bucket 생성**

`oracle-to-s3-cdc-athena-kiwony-20220410`

`별도로 S3 VPC endpoint는 생성하지 않고 진행`

---



#### Oracle Source 사전 작업

```
select 'ALTER TABLE '||owner||'.'||table_name||' ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;' from dba_tables where owner='OSHOP';

SQL> ALTER TABLE OSHOP.EMP ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
SQL> ALTER TABLE OSHOP.DEPT ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
SQL> ALTER TABLE OSHOP.DUMMY ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
```



---



**IAM Policy**

`oracle-to-s3-cdc-athena-kiwony-20220410-policy`

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
                "s3:ListBucket"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::oracle-to-s3-cdc-athena-kiwony-20220410*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::oracle-to-s3-cdc-athena-kiwony-20220410*"
        }
    ]
}
```

**IAM Update 후 아래의 권한만으로도 가능하다고 적혀 있음, 확인 필요 **

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:PutObjectTagging"
            ],
            "Resource": [
                "arn:aws:s3:::buckettest2/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::buckettest2"
            ]
        }
    ]
}

```



---

#### IAM Role

`oracle-to-s3-cdc-athena-kiwony-20220410-role`

```
trusted entity - DMS

ARN : 
arn:aws:iam::156227767883:role/oracle-to-s3-cdc-athena-kiwony-20220410-role
```

---

#### DMS Configuration

**RI 생성 **

---

**Source Endpoint 생성 **

---

**Target Endpoint 생성 **

```
Service access role ARN : arn:aws:iam::156227767883:role/oracle-to-s3-cdc-athena-kiwony-20220410-role
Bucket Name : oracle-to-s3-cdc-athena-kiwony-20220410
Extra connection attributes
 : PreserveTransactions=true;CdcPath=ChangedData;

```

```
PreserveTransactions=true일 경우 cdcPath는 mandatory임
SYSTEM ERROR MESSAGE:Feature PreserveTransactions requires cdcPath setting
```



![image-20220410191016000](images/image-20220410191016000.png)



---

#### Task 생성

```
S3가 Target일 경우 Validation Enable 불가
```

```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "587257363",
            "rule-name": "587257363",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "OSHOP"
            },
            "rule-action": "rename",
            "value": "OSHOP",
            "old-value": null
        },
        {
            "rule-type": "selection",
            "rule-id": "587250393",
            "rule-name": "587250393",
            "object-locator": {
                "schema-name": "OSHOP",
                "table-name": "DUMMY"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "586169021",
            "rule-name": "586169021",
            "object-locator": {
                "schema-name": "OSHOP",
                "table-name": "DEPT"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "586163821",
            "rule-name": "586163821",
            "object-locator": {
                "schema-name": "OSHOP",
                "table-name": "EMP"
            },
            "rule-action": "include",
            "filters": []
        }
    ]
}
```



---

#### Task 확인 및 S3 확인

![image-20220410195347229](images/image-20220410195347229.png)

![image-20220410195400771](images/image-20220410195400771.png)

![image-20220410195418527](images/image-20220410195418527.png)

![image-20220410195441509](images/image-20220410195441509.png)

![image-20220410195505804](images/image-20220410195505804.png)

![image-20220410195937213](images/image-20220410195937213.png)



---

#### Athena로 Query 해보기

**glue로 crawling 하고 조회**

![image-20220410200812386](images/image-20220410200812386.png)

---

#### CDC - Insert emp

```
insert into emp values (9901, 'john', 'IT', 7698, sysdate, 10000, 0, 20);
insert into emp(empno, ename, job, mgr, hiredate, sal, deptno) values (9902, 'jane', 'IT', 7698, sysdate, 11000, 20);
commit;
```

![image-20220410201257657](images/image-20220410201257657.png)

![image-20220410201352876](images/image-20220410201352876.png)

![image-20220410201435679](images/image-20220410201435679.png)

---

#### CDC -Insert dummy

```
insert into dummy values (4, 'kk', 4000, 'hi');
insert into dummy(id, name, sal) values (5, 'yy', 3000);
commit;
```

![image-20220410201640474](images/image-20220410201640474.png)

![image-20220410201706470](images/image-20220410201706470.png)

![image-20220410201725023](images/image-20220410201725023.png)

---

#### Athena 다시 한번 Test - 잘 동작함(query2, query 3 모두)

![image-20220410201754931](images/image-20220410201754931.png)

![image-20220410201924625](images/image-20220410201924625.png)



---

#### Crawler 다시 수행(update된 dummy table은 double -> bigint 수동으로 바꾼 영향도)

![image-20220410201944826](images/image-20220410201944826.png)

![image-20220410202234686](images/image-20220410202234686.png)

![image-20220410202218595](images/image-20220410202218595.png)

**두개의 CDC 파일 모두 Athena에서 조회 결과 없음 **

![image-20220410202340120](images/image-20220410202340120.png)

---

#### CDC Update - EMP

```
update emp set sal=20000 where empno=9901;
update emp set DEPTNO=30 where empno=9902;
commit;
```

![image-20220410202650592](images/image-20220410202650592.png)

![image-20220410202749645](images/image-20220410202749645.png)

![image-20220410202811380](images/image-20220410202811380.png)

![image-20220410202917511](images/image-20220410202917511.png)

---

#### Crawler 다시 수행

![image-20220410203058637](images/image-20220410203058637.png)

![image-20220410203129978](images/image-20220410203129978.png)

---

#### CDC - Update dummy

```
update dummy set sal=10000 where id=1;
update dummy set details='sa' where id=2;
update dummy set sal=20000 where id=2;
update dummy set details='fin' where id=2;
commit;
```

![image-20220410203306230](images/image-20220410203306230.png)

![image-20220410203342480](images/image-20220410203342480.png)

![image-20220410203402183](images/image-20220410203402183.png)

**athena 조회 결과는 위와 동일 **

---

#### CDC - cdcInsertsOnly=true test

**Create S3 target endpoint with cdcInsertsOnly**

```
cdcInsertsOnly=true;
```

![image-20220410204044005](images/image-20220410204044005.png)

![image-20220410204431708](images/image-20220410204431708.png)

![image-20220410204545230](images/image-20220410204545230.png)

![image-20220410204608113](images/image-20220410204608113.png)

---

#### Crawler 다시 수행

![image-20220410204627032](images/image-20220410204627032.png)

![image-20220410204735458](images/image-20220410204735458.png)

![image-20220410204804415](images/image-20220410204804415.png)

---

#### CDC - Insert emp

```
insert into emp values (8801, 'GI', 'IT', 7698, sysdate, 10000, 0, 20);
insert into emp(empno, ename, job, mgr, hiredate, sal, deptno) values (8802, 'BOB', 'IT', 7698, sysdate, 11000, 20);

commit;
```

![image-20220410212208379](images/image-20220410212208379.png)

![image-20220410212220872](images/image-20220410212220872.png)

![image-20220410212240961](images/image-20220410212240961.png)

**추가된 Data가 같은 Folder에 있기 때문에 바로 데이터 조회 가능**

![image-20220410212300370](images/image-20220410212300370.png)

![image-20220410212703181](images/image-20220410212703181.png)



---

#### CDC - Insert Dummy

```
insert into dummy values(6,'jj',3000,'ff');
insert into dummy(id, name, sal) values (7,'zz',5000);
commit;

```

![image-20220410212449819](images/image-20220410212449819.png)

![image-20220410212501593](images/image-20220410212501593.png)

![image-20220410212518918](images/image-20220410212518918.png)

![image-20220410212532787](images/image-20220410212532787.png)

**추가된 Data가 같은 Folder에 있기 때문에 바로 데이터 조회 가능**

![image-20220410212554124](images/image-20220410212554124.png)