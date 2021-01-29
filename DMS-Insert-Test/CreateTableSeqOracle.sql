create sequence dummy_seq start with 1 increment by 1;
create table dummy(myseq int, mytime timestamp, name varchar2(100), ssn varchar2(100), constraint pk_dummy primary key(myseq));

alter table dummy add supplemental log data (primary key) columns;
alter database add supplemental log data;