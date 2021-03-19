# NODE
FROM ubuntu:20.04

ENV MYSQL_HOME=/usr/local/mysql

RUN apt update -yqq; \
    apt install -yqq net-tools \
        nano \
        wget \
        iputils-ping \
        libncurses5 \
        libaio1 \
        libaio-dev \
        autoconf \
        libnuma-dev; \
    groupadd mysql; \
    useradd -g mysql mysql

WORKDIR /usr/local

RUN wget https://downloads.mysql.com/archives/get/p/14/file/mysql-cluster-gpl-7.3.26-linux-glibc2.12-x86_64.tar.gz; \
    tar -xzvf mysql-cluster-gpl-7.3.26-linux-glibc2.12-x86_64.tar.gz; \
    ln -s mysql-cluster-gpl-7.3.26-linux-glibc2.12-x86_64 mysql

WORKDIR ${MYSQL_HOME}

ENV MYSQL_DATA_DIR=/usr/local/mysql/data

COPY config/my.conf /etc/my.cnf

COPY config/config.ini /var/lib/mysql-cluster/config.ini

COPY entrypoint_node.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh ${MYSQL_HOME}/support-files/mysql.server

ENTRYPOINT [ "/entrypoint.sh" ]
