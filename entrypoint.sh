#!/bin/bash
ndb_mgmd -f /var/lib/mysql-cluster/config.ini --configdir=/var/lib/mysql-cluster/ --ndb-nodeid=1 --reload

exec "${@}"
