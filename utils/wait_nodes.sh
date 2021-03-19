#!/bin/bash
function wait_nodes {
	WAIT_HOSTNAMES_ARR=(${WAIT_HOSTNAMES})
    echo "Waiting for $WAIT_HOSTNAMES"
	
	for HOSTNAME in "${WAIT_HOSTNAMES_ARR[@]}"; do
        let i=1

		while ! getent hosts "${HOSTNAME}"; do
		    echo "Ping ${HOSTNAME} for $i times"
			sleep 1
			let "i++"
		done
	done
}
