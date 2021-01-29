use testDB;

start transaction;
insert into tblColumns (tblName, columnName, dataType)
values (LEFT(UUID(), 8), LEFT(MD5(RAND()), 8), RIGHT(MD5(RAND()), 8));
commit;
