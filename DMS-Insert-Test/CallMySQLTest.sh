#!/bin/bash

SET=$(seq 0 10000)
for i in $SET

do

    mysql -u****** -p******* -h******** < callInsert.sql

done
