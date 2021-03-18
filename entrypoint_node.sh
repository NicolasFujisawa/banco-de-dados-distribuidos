#!/bin/bash

/usr/local/mysql/bin/ndbd --initial
./support-files/mysql.server start
