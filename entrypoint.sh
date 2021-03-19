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

ndb_mgmd -f /var/lib/mysql-cluster/config.ini \
    --configdir=/var/lib/mysql-cluster/ \
    --ndb-nodeid=1 \
    --reload

tail -f /var/lib/mysql-cluster/ndb_1_cluster.log
