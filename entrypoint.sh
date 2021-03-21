#!/bin/bash
source /wait_nodes.sh
wait_nodes

ndb_mgmd -f /var/lib/mysql-cluster/config.ini \
    --configdir=/var/lib/mysql-cluster/ \
    --ndb-nodeid=1 \
    --reload

tail -f /var/lib/mysql-cluster/ndb_1_cluster.log
