#!/bin/bash
source /wait_nodes.sh
wait_nodes

if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
    scripts/mysql_install_db -user=mysql -datadir=${MYSQL_HOME}/data
    chown -R root:mysql ${MYSQL_HOME}
    chown -R mysql ${MYSQL_HOME}/data
else
    echo "Data directory already exist"
fi

/usr/bin/ndbd --initial
${MYSQL_HOME}/support-files/mysql.server start

tail -f ${MYSQL_HOME}/data/*.err
