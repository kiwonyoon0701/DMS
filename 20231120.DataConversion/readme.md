# DMS를 활용한 Raw Data Conversion Test



1. Target DB Schema 생성

```
create user newuser identified by newuser default tablespace users temporary tablespace temp quota unlimited on users;
grant connect,resource, dba to newuser;
```



---

2. sport_league table DDL

```
 CREATE TABLE "DMS_SAMPLE"."SPORT_LEAGUE" 
   (	"SPORT_TYPE_NAME" VARCHAR2(15) NOT NULL ENABLE, 
	"SHORT_NAME" VARCHAR2(10) NOT NULL ENABLE, 
	"LONG_NAME" VARCHAR2(60) NOT NULL ENABLE, 
	"DESCRIPTION" VARCHAR2(120), 
	 CONSTRAINT "SPORT_LEAGUE_PK" PRIMARY KEY ("SHORT_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE, 
	 SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS, 
	 CONSTRAINT "SL_SPORT_TYPE_FK" FOREIGN KEY ("SPORT_TYPE_NAME")
	  REFERENCES "DMS_SAMPLE"."SPORT_TYPE" ("NAME") ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS";
```



---

3. Query SPORT_LEAGUE;

```
select * from sport_league;
```

![image-20231120215510928](images/image-20231120215510928.png)



---

4. DMS TASK Table Mapping (transformation rule 2에서 case when으로 data 처리, FULL Load / CDC 모두 동작)

```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "478893211",
            "rule-name": "478893211",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "DMS_SAMPLE"
            },
            "rule-action": "rename",
            "value": "NEWUSER",
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-action": "add-column",
            "rule-target": "column",
            "object-locator": {
                "schema-name": "DMS_SAMPLE",
                "table-name": "SPORT_LEAGUE"
            },
            "value": "NEW_COLUMN",
            "expression": " CASE WHEN ($SHORT_NAME)=='MLB' THEN 'BASEBALL' ELSE 'NOT BASEBALL' END",
            "data-type": {
                "type": "string",
                "length": 50
            }
        },
        {
            "rule-type": "selection",
            "rule-id": "478883988",
            "rule-name": "478883988",
            "object-locator": {
                "schema-name": "DMS_SAMPLE",
                "table-name": "SPORT_LEAGUE"
            },
            "rule-action": "include",
            "filters": []
        }
    ]
}
```



---

5. TASK 실행 후 TARGET DB쪽에 NEW_COLUMN이 추가 됨을 확인.

![image-20231120215630717](images/image-20231120215630717.png)



---

6. 데이터도 원하는데로 들어감을 확인

![image-20231120215651872](images/image-20231120215651872.png)





---

## Test Case 2



1. SPORT_TYPE_NAME COLUMN의 Data를 조건으로 Data Converting

```
{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "478893211",
            "rule-name": "478893211",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "DMS_SAMPLE"
            },
            "rule-action": "rename",
            "value": "NEWUSER",
            "old-value": null
        },
        {
            "rule-type": "transformation",
            "rule-id": "2",
            "rule-name": "2",
            "rule-action": "add-column",
            "rule-target": "column",
            "object-locator": {
                "schema-name": "DMS_SAMPLE",
                "table-name": "SPORT_LEAGUE"
            },
            "value": "NEW_COLUMN",
            "expression": " CASE WHEN ($SPORT_TYPE_NAME)=='baseball' THEN 'BASEBALL' ELSE 'NOT BASEBALL' END",
            "data-type": {
                "type": "string",
                "length": 50
            }
        },
        {
            "rule-type": "selection",
            "rule-id": "478883988",
            "rule-name": "478883988",
            "object-locator": {
                "schema-name": "DMS_SAMPLE",
                "table-name": "SPORT_LEAGUE"
            },
            "rule-action": "include",
            "filters": []
        }
    ]
}
```





---

2. Insert 실행

```
insert into SPORT_LEAGUE values ('baseball', 'MLB2', 'abc','def');
commit;
```



---

3. 반영 결과 확인 (row3 - SPORT_TYPE_NAME이 baseball이 들어와서 NEW_COLUMN에 'BASEBALL'로 Insert)

![image-20231121092421616](images/image-20231121092421616.png)





---

## Test 3



1. Test2에서 insert한 Row 삭제

```
delete SPORT_LEAGUE where SHORT_NAME='MLB2';
commit;
```



---

2. SPORT_TYPE_NAME=base로 Data Insert

```
insert into sport_type values ('base','abc'); // FK constraint때문에 입력
commit;

insert into SPORT_LEAGUE values ('base', 'MLB2', '1','2');
commit;
```



![image-20231121092720238](images/image-20231121092720238.png)



---

3. Update 동작 여부 확인. base => baseball로 변경 시 row3처럼 NEW_COLUMN이 의도한대로 변경 됨을 확인

```
update SPORT_LEAGUE set SPORT_TYPE_NAME='baseball' where SPORT_TYPE_NAME='base';
commit;
```

![image-20231121092812725](images/image-20231121092812725.png)
