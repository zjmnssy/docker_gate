# Set the base image to centos
FROM ubuntu:latest

# File Author
MAINTAINER grootcz

# Install some start shell scripts
ADD ./keepContainerAlive.sh /root

# Set default work dir
WORKDIR /root/

RUN mkdir /root/service

# Set the env
ENV ETCDCTL_API=3

# Expose ports
EXPOSE 8888

# Set the default command to execute
ENTRYPOINT exec /root/keepContainerAlive.sh
