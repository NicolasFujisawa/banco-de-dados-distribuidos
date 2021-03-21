FROM ubuntu:20.04

RUN apt update -yq; \
    apt install -yqq \
    net-tools \
    nano \
    wget \
    iputils-ping \
    libncurses5

ENV MYSQL_DOWNLOAD_PATH=/usr/src/mysql-mgm
ENV MYSQL_FILE=mysql-cluster-gpl-7.3.26-linux-glibc2.12-x86_64
ENV MYSQL_HOME=/var/lib/mysql-cluster

RUN mkdir -p ${MYSQL_DOWNLOAD_PATH}; \
    cd ${MYSQL_DOWNLOAD_PATH}; \
    wget https://downloads.mysql.com/archives/get/p/14/file/${MYSQL_FILE}.tar.gz; \
    tar -xzvf ${MYSQL_FILE}.tar.gz; \
    cp ${MYSQL_FILE}/bin/ndb_mgm* /usr/bin; \
    chmod +x /usr/bin/ndb_mgm*; \
    cd /var/lib

RUN rm -rf ${MYSQL_DOWNLOAD_PATH}; \
    mkdir -p ${MYSQL_HOME}

WORKDIR ${MYSQL_HOME}

COPY config/config.ini ${MYSQL_HOME}/config.ini

COPY entrypoint.sh utils/wait_nodes.sh /

RUN ls -la /; chmod +x /entrypoint.sh /wait_nodes.sh

ENTRYPOINT [ "/entrypoint.sh" ]
