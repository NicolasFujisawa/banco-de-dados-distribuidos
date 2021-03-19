#!/bin/bash
function wait_nodes {
	HOSTNAMES_ARR=(${HOSTNAMES})
    echo "Waiting for $HOSTNAMES"
	
	for HOSTNAME in "${HOSTNAMES_ARR[@]}"; do
		echo "Waiting for ${HOSTNAME}"
		while ! getent hosts "${HOSTNAME}"; do
			sleep 1
		done
	done
}

wait_nodes

if [ ! -d "$MYSQL_DATA_DIR/mysql" ]; then
    scripts/mysql_install_db -user=mysql -datadir=${MYSQL_HOME}/data
    chown -R root:mysql ${MYSQL_HOME}
    chown -R mysql ${MYSQL_HOME}/data
    mv bin/* /usr/bin
    rm -rf bin
    ln -s /usr/bin ${MYSQL_HOME}/bin
else
    echo "Data directory already exist"
fi

/usr/bin/ndbd --initial
${MYSQL_HOME}/support-files/mysql.server start

tail -f ${MYSQL_HOME}/data/*.err
