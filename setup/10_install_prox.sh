#!/bin/bash

PROX_VER=$1

#Getting machine's IP address
NET=$(route | grep '^default' | grep -o '[^ ]*$')
ipaddr=$(ifconfig $NET  | grep -ie "inet" | grep -ioEe "([0-9]+\.){3}[0-9]+")
ipaddr=($ipaddr)
IP=${ipaddr[0]}
# Resetting state for the system
echo 0 > /opt/flag.txt
#Getting PROX's source code
mkdir -p /opt/crucio
cd /opt/crucio
rm -rf PROX*
git clone https://github.com/nvf-crucio/PROX
cd PROX
git checkout $PROX_VER

if [ $PROX_VER = 85806f9431cc2d70ad5a82d3d07eff78af3486ea ]
then
	patch -p1 < /opt/patch-files/common-patchs/patch/prox/more-rxtx-desc-and-larger-mbuf-cache.patch
fi

# Building PROX
export RTE_SDK=/opt/crucio/dpdk
make install
