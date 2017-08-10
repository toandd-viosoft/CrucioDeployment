#!/bin/bash

DATS_VER=$1

echo "Getting DATS for TG"
# Get DATS
cd /opt/crucio
rm -rf DATS*
#git clone https://github.com/nvf-crucio/DATS
git clone https://github.com/toandd-viosoft/CDATS.git DATS
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

if [ $DATS_VER = 7312cd45ad0eff9fda3360e01d8c9f415ed42fe5 ]
then
	cd /opt/crucio
	patch -d DATS/tests/ -p1 < /opt/patch-files/common-patchs/patch/dats/adjust-mempool-for-more-rxtx-desc.patch
        
	# From 21-07-2017, validium supported adjusting parameters
	# don't need to hardcode
	# Gettign new patchs for DATS
	# cd DATS/
	# mv tests/prox-configs/ tests/prox-configs.old/
	# rm -rf dats-patchs/
	# git clone https://github.com/toandd-viosoft/dats-patchs.git
	# cd dats-patchs
	# git checkout 06a31252adac6a3e4d47e9743de6f941dc97376c
	# cd ..
	# cp -r dats-patchs/baremetal-patchs/prox-configs/ tests/
	# chmod +x dats.py
fi

