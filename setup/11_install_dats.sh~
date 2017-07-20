#!/bin/bash

DATS_VER=$1

echo "Getting DATS for TG"
# Get DATS
cd /opt/crucio
rm -rf DATS*
git clone https://github.com/nvf-crucio/DATS
cd DATS
git checkout $DATS_VER

patch -f dats/remote_control.py < /opt/nfvscripts/setup/remote_control.py.patch

if [ $DATS_VER = f1da5139b2c1a9134abfb6f304c980cd445c9a38 ]
then
	cd ../
	patch -d DATS/tests/ -p1 < /opt/patch-files/common-patchs/patch/dats/adjust-mempool-for-more-rxtx-desc.patch

	# Gettign new patchs for DATS
	cd DATS/
	mv tests/prox-configs/ tests/prox-configs.old/
	rm -rf dats-patchs/
	git clone https://github.com/toandd-viosoft/dats-patchs.git
	cd dats-patchs
	git checkout 06a31252adac6a3e4d47e9743de6f941dc97376c
	cd ..
	cp -r dats-patchs/baremetal-patchs/prox-configs/ tests/
	chmod +x dats.py
fi

