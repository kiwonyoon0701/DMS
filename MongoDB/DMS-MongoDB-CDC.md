## Enable OPLOG

**Enable OPLOG**

```
[ec2-user@ip-172-31-19-93 etc]\$ sudo diff ./mongod.conf.org ./mongod.conf
37a38,39

> replication:
> replSetName: replSet

[ec2-user@ip-172-31-19-93 etc]\$ sudo service mongod restart
```

**rs.initiate and check oplog in local db**

```
[ec2-user@ip-172-31-19-93 ~]\$ mongo localhost

> use admin;
> switched to db admin
> rs.initiate()
> {

        "info2" : "no configuration specified. Using a default configuration for the set",
        "me" : "ip-172-31-19-93:27017",
        "ok" : 1,
        "$clusterTime" : {
                "clusterTime" : Timestamp(1605683740, 1),
                "signature" : {
                        "hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
                        "keyId" : NumberLong(0)
                }
        },
        "operationTime" : Timestamp(1605683740, 1)

}
replSet:SECONDARY>
replSet:PRIMARY>

replSet:PRIMARY> show tables
oplog.rs
replset.election
replset.initialSyncId
replset.minvalid
replset.oplogTruncateAfterPoint
startup_log
system.replset
system.rollback.id
```

**Insert Data in Source MongoDB**

```
replSet:PRIMARY> m = { ename : "김몽고", depart : "개발팀", status : "A", height: 170 }
{ "ename" : "김몽고", "depart" : "개발팀", "status" : "A", "height" : 170 }
replSet:PRIMARY> db.zips.insert(m)
WriteResult({ "nInserted" : 1 })
replSet:PRIMARY> db.zips.find({ename:"김몽고"})
{ "_id" : ObjectId("5fb4cc649a2d4f12b3e83eff"), "ename" : "김몽고", "depart" : "개발팀", "status" : "A", "height" : 170 }
```

**Check Data in Target DocumentDB**

```
rs0:PRIMARY> db.zips.count()
29353

--> After Source insert
rs0:PRIMARY> db.zips.count()
29354
rs0:PRIMARY> db.zips.find({ename:"김몽고"})
{ "_id" : ObjectId("5fb4cc649a2d4f12b3e83eff"), "depart" : "개발팀", "ename" : "김몽고", "height" : 170, "status" : "A" }
```
