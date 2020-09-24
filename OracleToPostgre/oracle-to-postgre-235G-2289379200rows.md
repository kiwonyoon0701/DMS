Table
ORDERS001 ~ ORDERS100

Each Table Rows : 2289,3792
Each Segment Size : 2.35G

Total Rows : 22,8937,9200
Total Segment Size : 235G

```
SQL> SELECT SEGMENT_NAME, TABLESPACE_NAME, round(BYTES/1024/1024/1024,2)||'GB' as SEG_SIZE, BLOCKS, EXTENTS
    FROM DBA_SEGMENTS
    WHERE OWNER='SOE2'
    ORDER BY SEGMENT_NAME;  2    3    4

SEGMENT_NAME									  TABLESPACE_NAME		 SEG_SIZE					BLOCKS	  EXTENTS
--------------------------------------------------------------------------------- ------------------------------ ------------------------------------------ ---------- ----------
ORDERS001									  SOE				 2.33GB 					305664	     2388
ORDERS002									  SOE				 2.35GB 					308608	     2411
ORDERS003									  SOE				 2.36GB 					308864	     2413
ORDERS004									  SOE				 2.36GB 					308992	     2414
ORDERS005									  SOE				 2.36GB 					308864	     2413
ORDERS006									  SOE				 2.36GB 					308864	     2413
ORDERS007									  SOE				 2.36GB 					308736	     2412
ORDERS008									  SOE				 2.36GB 					308736	     2412
ORDERS009									  SOE				 2.36GB 					308864	     2413
ORDERS010									  SOE				 2.35GB 					308608	     2411
ORDERS011									  SOE				 2.36GB 					308864	     2413
ORDERS012									  SOE				 2.35GB 					308608	     2411
ORDERS013									  SOE				 2.35GB 					308608	     2411
ORDERS014									  SOE				 2.36GB 					308736	     2412
ORDERS015									  SOE				 2.36GB 					308736	     2412
ORDERS016									  SOE				 2.36GB 					308736	     2412
ORDERS017									  SOE				 2.36GB 					308864	     2413
ORDERS018									  SOE				 2.35GB 					308480	     2410
ORDERS019									  SOE				 2.35GB 					308480	     2410
ORDERS020									  SOE				 2.35GB 					308480	     2410
ORDERS021									  SOE				 2.36GB 					308736	     2412
ORDERS022									  SOE				 2.35GB 					308608	     2411
ORDERS023									  SOE				 2.35GB 					308608	     2411
ORDERS024									  SOE				 2.35GB 					308480	     2410
ORDERS025									  SOE				 2.35GB 					308224	     2408
ORDERS026									  SOE				 2.35GB 					308608	     2411
ORDERS027									  SOE				 2.35GB 					308608	     2411
ORDERS028									  SOE				 2.35GB 					308608	     2411
ORDERS029									  SOE				 2.35GB 					308608	     2411
ORDERS030									  SOE				 2.35GB 					308480	     2410
ORDERS031									  SOE				 2.35GB 					308608	     2411
ORDERS032									  SOE				 2.35GB 					308608	     2411
ORDERS033									  SOE				 2.35GB 					308608	     2411
ORDERS034									  SOE				 2.36GB 					308864	     2413
ORDERS035									  SOE				 2.35GB 					308608	     2411
ORDERS036									  SOE				 2.35GB 					308608	     2411
ORDERS037									  SOE				 2.36GB 					308736	     2412
ORDERS038									  SOE				 2.35GB 					308608	     2411
ORDERS039									  SOE				 2.35GB 					308480	     2410
ORDERS040									  SOE				 2.35GB 					308608	     2411
ORDERS041									  SOE				 2.35GB 					308608	     2411
ORDERS042									  SOE				 2.35GB 					308480	     2410
ORDERS043									  SOE				 2.35GB 					308480	     2410
ORDERS044									  SOE				 2.35GB 					308608	     2411
ORDERS045									  SOE				 2.35GB 					308480	     2410
ORDERS046									  SOE				 2.36GB 					308736	     2412
ORDERS047									  SOE				 2.36GB 					308864	     2413
ORDERS048									  SOE				 2.35GB 					308608	     2411
ORDERS049									  SOE				 2.35GB 					308608	     2411
ORDERS050									  SOE				 2.35GB 					308608	     2411
ORDERS051									  SOE				 2.35GB 					308480	     2410
ORDERS052									  SOE				 2.35GB 					308608	     2411
ORDERS053									  SOE				 2.35GB 					308352	     2409
ORDERS054									  SOE				 2.35GB 					308480	     2410
ORDERS055									  SOE				 2.35GB 					308352	     2409
ORDERS056									  SOE				 2.36GB 					308736	     2412
ORDERS057									  SOE				 2.36GB 					308736	     2412
ORDERS058									  SOE				 2.36GB 					308736	     2412
ORDERS059									  SOE				 2.35GB 					308608	     2411
ORDERS060									  SOE				 2.36GB 					308736	     2412
ORDERS061									  SOE				 2.35GB 					308608	     2411
ORDERS062									  SOE				 2.35GB 					308480	     2410
ORDERS063									  SOE				 2.35GB 					308608	     2411
ORDERS064									  SOE				 2.36GB 					308736	     2412
ORDERS065									  SOE				 2.35GB 					308480	     2410
ORDERS066									  SOE				 2.35GB 					308608	     2411
ORDERS067									  SOE				 2.35GB 					308480	     2410
ORDERS068									  SOE				 2.36GB 					308736	     2412
ORDERS069									  SOE				 2.35GB 					308480	     2410
ORDERS070									  SOE				 2.35GB 					308608	     2411
ORDERS071									  SOE				 2.35GB 					308608	     2411
ORDERS072									  SOE				 2.35GB 					308608	     2411
ORDERS073									  SOE				 2.35GB 					308352	     2409
ORDERS074									  SOE				 2.36GB 					308736	     2412
ORDERS075									  SOE				 2.36GB 					308736	     2412
ORDERS076									  SOE				 2.35GB 					308608	     2411
ORDERS077									  SOE				 2.35GB 					308608	     2411
ORDERS078									  SOE				 2.35GB 					308608	     2411
ORDERS079									  SOE				 2.35GB 					308608	     2411
ORDERS080									  SOE				 2.36GB 					308736	     2412
ORDERS081									  SOE				 2.36GB 					308736	     2412
ORDERS082									  SOE				 2.35GB 					308608	     2411
ORDERS083									  SOE				 2.36GB 					308736	     2412
ORDERS084									  SOE				 2.35GB 					308480	     2410
ORDERS085									  SOE				 2.36GB 					308992	     2414
ORDERS086									  SOE				 2.35GB 					308608	     2411
ORDERS087									  SOE				 2.35GB 					308608	     2411
ORDERS088									  SOE				 2.36GB 					308736	     2412
ORDERS089									  SOE				 2.36GB 					308736	     2412
ORDERS090									  SOE				 2.35GB 					308480	     2410
ORDERS091									  SOE				 2.36GB 					308864	     2413
ORDERS092									  SOE				 2.35GB 					308608	     2411
ORDERS093									  SOE				 2.35GB 					308608	     2411
ORDERS094									  SOE				 2.35GB 					308608	     2411
ORDERS095									  SOE				 2.36GB 					308736	     2412
ORDERS096									  SOE				 2.35GB 					308608	     2411
ORDERS097									  SOE				 2.35GB 					308352	     2409
ORDERS098									  SOE				 2.36GB 					308736	     2412
ORDERS099									  SOE				 2.35GB 					308480	     2410
ORDERS100									  SOE				 2.35GB 					308608	     2411

100 rows selected.

SQL> SELECT sum(round( BYTES/1024/1024/1024,2))||'GB' as SEG_SIZE
    FROM DBA_SEGMENTS
    WHERE OWNER='SOE2';  2    3

SEG_SIZE
------------------------------------------
235.32GB

SQL> select count(*) from orders001;

  COUNT(*)
----------
  22893792

```

```
OnPrem Oracle : m4.16xlarge

RDS Postgre : m5.12xlarge

RI : dms.r4.8xlarge



```

```
Table1~10
2,0000,0000
23.5G
9min
37,0000/sec full load speed

```
