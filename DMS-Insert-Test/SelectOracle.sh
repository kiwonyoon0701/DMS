#!/bin/bash
SET=$(seq 0 10000)
for i in $SET
do
sqlplus -s admin/PASSWORD@RDS<<EOF
SET HEADING OFF
select count(*),to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from SOE3.DUMMY;
exit
EOF
sleep 1
done