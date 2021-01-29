sqlplus -s SOE3/PASSWORD<<EOF
BEGIN
FOR i in 1..10000 LOOP
insert into dummy values (dummy_seq.nextVal, sysdate, DBMS_RANDOM.STRING('L', 20),  DBMS_RANDOM.STRING('L', 20));
commit;
END LOOP;
END;
/
exit
EOF