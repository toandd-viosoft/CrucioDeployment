#!/bin/bash

DPDK_VER=$1

path="$(pwd)"
#source $path/env.sh
NET=$(route | grep '^default' | grep -o '[^ ]*$')
ipaddr=$(ifconfig $NET  | grep -ie "inet" | grep -ioEe "([0-9]+\.){3}[0-9]+")
ipaddr=($ipaddr)
IP=${ipaddr[0]}

mkdir -p /opt/crucio
cd /opt/crucio
rm -rf dpdk*
wget http://www.dpdk.org/browse/dpdk/snapshot/dpdk-$DPDK_VER.tar.gz
tar -zxf dpdk-$DPDK_VER.tar.gz
ln -snf dpdk-$DPDK_VER dpdk

# Apply some changes
if [ "$3" == "" ] 
then
	cd /opt/crucio/dpdk
	cat > config/defconfig_$RTE_TARGET << EOF
#include "common_linuxapp"
# OVS-specific customization
CONFIG_RTE_BUILD_COMBINE_LIBS=y
CONFIG_RTE_LIBRTE_VHOST=y
CONFIG_RTE_LIBRTE_VHOST_USER=y
#
CONFIG_RTE_ARCH_64=y
CONFIG_RTE_TOOLCHAIN="gcc"
CONFIG_RTE_TOOLCHAIN_GCC=y
CONFIG_RTE_MACHINE="native"
CONFIG_RTE_ARCH="x86_64"
CONFIG_RTE_ARCH_X86_64=y
EOF

	cd /opt/crucio/dpdk
	patch -p1 < /opt/patch-files/common-patchs/patch/dpdk/vhost-ignore-cleared-virtqueue.patch
else
	echo "This is tester, do nothing"
fi

cd /opt/crucio/dpdk
make install T=$RTE_TARGET
