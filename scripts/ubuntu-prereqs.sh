#!/bin/bash

sudo add-apt-repository ppa:snappy-dev/beta &&
sudo apt-get update -y &&
sudo apt-get upgrade -y &&
sudo apt-get install -y snappy-tools bzr curl git mercurial binutils-arm-linux-gnueabihf gccgo-4.8-arm-linux-gnueabihf dosfstools fakeroot

sudo mkdir -p /usr/local/go &&
sudo chmod 2775 /usr/local/go &&
sudo chown $(whoami).$(whoami) /usr/local/go &&
git clone https://go.googlesource.com/go /usr/local/go &&
cd /usr/local/go &&
git checkout go1.4.2 &&
cd src &&
CC_FOR_TARGET=arm-linux-gnueabi-gcc CGO_ENABLED=1 GOOS=linux GOARCH=arm ./make.bash

mkdir ~/go
cat >> ~/.bashrc <<EOF
export GOROOT=/usr/local/go
export GOPATH=\$HOME/go
export PATH=\$GOPATH/bin:\$GOROOT/bin:\$PATH
EOF

# git clone git@github.com:ninjasphere/ninjasphere-snappy.git ~/ninjasphere-snappy