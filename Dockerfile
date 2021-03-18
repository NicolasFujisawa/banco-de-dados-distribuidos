FROM ubuntu:20.04 as ubuntu

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


# MASTER
FROM ubuntu as master

RUN rm -rf ${MYSQL_HOME}; \
    mkdir -p /var/lib/mysql-cluster

WORKDIR /var/lib/mysql-cluster

COPY config/config.ini /var/lib/mysql-cluster/config.ini

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]


# NODE
FROM ubuntu as node

RUN apt install -yqq libaio1 \
        libaio-dev \
        autoconf \
        libnuma-dev

ENV MYSQL_DATA_DIR=/usr/local/mysql/data

RUN ln -s ${MYSQL_HOME}/${MYSQL_FILE} /mysql; \
    groupadd mysql; \
    useradd -g mysql mysql; \
    mkdir -p ${MYSQL_DATA_DIR}; \
    cd /mysql; \
    scripts/mysql_install_db -user=mysql -datadir=${MYSQL_DATA_DIR}; \
    chown -R root:mysql .; \
    chown -R mysql:mysql ${MYSQL_DATA_DIR}; \
    mkdir -p /var/lib/mysql-cluster; \
    mkdir -p /usr/local/mysql/bin; \
    cp /mysql/bin/* /usr/local/mysql/bin/

COPY config/my.conf /etc/my.cnf

COPY config/config.ini /var/lib/mysql-cluster/config.ini

COPY entrypoint_node.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

WORKDIR /mysql

ENTRYPOINT [ "/entrypoint.sh" ]
