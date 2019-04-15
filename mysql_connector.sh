#!/bin/bash

echo "* 等待 MySQL 启动……"
# Give 60 seconds for master and slave to come up
sleep 60

echo "* master 创建同步用户……"

mysql --host 10.20.1.2 -uroot -p$MYSQL_MASTER_PASSWORD -AN -e "GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' IDENTIFIED BY '123456';"
mysql --host 10.20.1.2 -uroot -p$MYSQL_MASTER_PASSWORD -AN -e 'flush privileges;'


echo "* 设置从库"

Master_Position=$(eval "mysql --host 10.20.1.2 -uroot -p$MYSQL_MASTER_PASSWORD -e 'show master status \G' | grep Position | sed -n -e 's/^.*: //p'")
Master_File=$(eval "mysql --host 10.20.1.2 -uroot -p$MYSQL_MASTER_PASSWORD -e 'show master status \G'     | grep File     | sed -n -e 's/^.*: //p'")

mysql --host 10.20.1.3 -uroot -p$MYSQL_SLAVE_PASSWORD -AN -e "CHANGE MASTER TO master_host='10.20.1.2', master_port=3306, \
        master_user='repl', master_password='123456', master_log_file='$Master_File', \
        master_log_pos=$Master_Position;"


echo "* 启动 slave"
mysql --host 10.20.1.3 -uroot -p$MYSQL_SLAVE_PASSWORD -AN -e "start slave;"

echo "Increase the max_connections to 2000"
mysql --host 10.20.1.2 -uroot -p$MYSQL_MASTER_PASSWORD -AN -e 'set GLOBAL max_connections=2000';
mysql --host 10.20.1.3 -uroot -p$MYSQL_SLAVE_PASSWORD -AN -e 'set GLOBAL max_connections=2000';

mysql --host mysqlslave -uroot -p$MYSQL_SLAVE_PASSWORD -e "show slave status \G"

echo "----------------------"
echo "----------------------"
echo "* MySQL 主从同步已创建 *"
echo "----------------------"
echo "----------------------"

