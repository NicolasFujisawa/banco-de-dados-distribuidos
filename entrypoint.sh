#!/bin/bash

function wait_nodes {
	WAIT_HOSTNAMES_ARR=(${WAIT_HOSTNAMES})
    echo "Waiting for $WAIT_HOSTNAMES"
	
	for HOSTNAME in "${WAIT_HOSTNAMES_ARR[@]}"; do
		echo "Waiting for ${HOSTNAME}"
		while ! getent hosts "${HOSTNAME}"; do
			sleep 1
		done
	done
}

wait_nodes

ndb_mgmd -f /var/lib/mysql-cluster/config.ini \
    --configdir=/var/lib/mysql-cluster/ \
    --ndb-nodeid=1 \
    --reload

tail -f /var/lib/mysql-cluster/ndb_1_cluster.log
