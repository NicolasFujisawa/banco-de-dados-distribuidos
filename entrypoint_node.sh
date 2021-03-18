#!/bin/bash

/mysql/scripts/mysql_install_db -user=mysql -datadir=${MYSQL_DATA_DIR}
/usr/local/mysql/bin/ndbd --initial
./support-files/mysql.server start
