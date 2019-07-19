# syntax=docker/dockerfile:1.0.0-experimental
FROM ubuntu:18.04

RUN apt update \
    && apt install --no-install-recommends -y python3-pip python3-setuptools \
    && pip3 install awscli==1.16.163 \
    && apt-get install -y curl jq telnet dnsutils \
    && apt-get clean && rm -rf /var/lib/apt/list/*
