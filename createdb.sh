#!/bin/bash

echo '=============================='
echo 'create database '${DB_NAME} > /tmp/createdb.sql
cat /tmp/createdb.sql

mysql -h${DB_HOST} -P${DB_PORT} -u${DB_USER} -p${DB_PASS} < /tmp/createdb.sql

