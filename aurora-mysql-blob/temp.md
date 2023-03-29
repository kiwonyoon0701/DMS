```
create database demo;
use demo;

CREATE TABLE gallery (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (255) NOT NULL,
image BLOB NOT NULL
);

```



```
SHOW VARIABLES LIKE 'max_allowed_packet';

max_allowed_packet
cluster 반영해도 안됨
db 반영해도 안됨 => show 해도 그대로 예전 값 보임

db reboot후 확인 결과 변경 확인

max_allowed_packet	1073741824

이후 아래처럼 정상 업로드 완료
[ec2-user@asmtest ~]$ python3.7 insert.py 
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed


```





```
call mysql.rds_set_configuration('binlog retention hours', 24);

binlog_format :: ROW
binlog_row_image :: FULL
binlog_checksum :: NONE


https://repost.aws/knowledge-center/dms-error-null-value-column


```



```
--	#	Time	Action	Message	Duration / Fetch
0	1	22:15:16	call mysql.rds_set_configuration('binlog retention hours', 24)	Error Code: 1175.
 You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column
 To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec
 
 ==> SQL editor에서 수정
```



```
[ec2-user@asmtest ~]$ python3.7 insert.py 
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
[ec2-user@asmtest ~]$ python3.7 insert.py 
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
Inserting BLOB into python_employee table
Image and file inserted successfully as a BLOB into python_employee table None
MySQL connection is closed
```



```
https://519573440819.signin.aws.amazon.com/console
```



```
https://github.com/widdix/aws-cf-templates/blob/master/state/rds-aurora.yaml
```







