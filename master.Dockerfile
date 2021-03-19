FROM ubuntu:20.04

RUN apt update -yq; \
    apt install -yqq \
    net-tools \
    nano \
    wget \
    iputils-ping \
    libncurses5

ENV MYSQL_HOME=/usr/src/mysql-mgm
ENV MYSQL_FILE=mysql-cluster-gpl-7.3.26-linux-glibc2.12-x86_64

RUN mkdir -p ${MYSQL_HOME}; \
    cd ${MYSQL_HOME}; \
    wget https://downloads.mysql.com/archives/get/p/14/file/${MYSQL_FILE}.tar.gz

WORKDIR ${MYSQL_HOME}

RUN tar -xzvf ${MYSQL_FILE}.tar.gz; \
    cp ${MYSQL_FILE}/bin/ndb_mgm* /usr/bin; \
    chmod +x /usr/bin/ndb_mgm*; \
    cd /var/lib

RUN rm -rf ${MYSQL_HOME}; \
    mkdir -p /var/lib/mysql-cluster

WORKDIR /var/lib/mysql-cluster

COPY config/config.ini /var/lib/mysql-cluster/config.ini

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
