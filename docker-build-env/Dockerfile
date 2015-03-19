FROM ubuntu:14.04
MAINTAINER Theo Julienne <theo@ninjablocks.com>

ADD go1.4.2.linux-amd64.tar.gz /usr/local
RUN echo -n 'export GOROOT=/usr/local/go\nexport GOBIN=$GOROOT/bin\nexport PATH=$GOBIN:$PATH' > /etc/profile.d/golang.sh

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:snappy-dev/beta
RUN apt-get update
RUN apt-get install -y build-essential snappy-tools bzr curl git wget parted dosfstools

RUN echo -n 'export GOPATH=/data/.gopath\nexport PATH=$GOPATH/bin:$PATH' > /etc/profile.d/golang-hack.sh


CMD sudo -i /bin/bash