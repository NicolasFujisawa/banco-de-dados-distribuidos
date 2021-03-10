FROM ubuntu:20.04

RUN apt update -yq; \
    apt install -yqq net-tools \
    iputils-ping
