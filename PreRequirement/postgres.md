

## 1. AWS DMS - Postgres PreRequirement Check Page

https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Source.PostgreSQL.html



## 2. Supported Version

postgreSQL 9.4 and later(10.x, 11.x, 12.x, 13.x, 14.x)



| PostgreSQL source version | AWS DMS version to use               |
| :------------------------ | :----------------------------------- |
| 9.x, 10.x, 11.x, 12.x     | Use any available AWS DMS version.   |
| 13.x                      | Use AWS DMS version 3.4.3 and above. |
| 14.x                      | Use AWS DMS version 3.4.7 and above. |



## 3. self-managed PostgreSQL

#### 1. 작업 별 필요 Permission

| Task            | Permissions      |
| :-------------- | :--------------- |
| Full Load       | select on tables |
| CDC             | superuser        |
| Full Load + CDC | superuser        |



#### 2. pg.hba.conf 수정

```

# Replication Instance
host all all 12.3.4.56/00 md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
host replication dms 12.3.4.56/00 md5
            
```



#### 3. postgresql.conf 수정

```
wal_level = logical
max_replication_slots를 1보다 큰 값으로 지정합니다. (작업 갯수보다 크게 설정)
max_wal_senders를 1보다 큰 값으로 지정합니다. (작업 갯수만큼 설정)
wal_sender_timeout 60000 설정시 1분 Timeout
```

