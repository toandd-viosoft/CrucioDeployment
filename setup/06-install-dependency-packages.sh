#!/bin/sh
YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

if [ "$APT_GET_CMD" != "" ]; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  sudo apt-get -y install yum-utils wget vim tcpdump screen expect
  sudo apt-get -y install sed gawk grep wget tar gzip bzip2 zip unzip coreutils pciutils psmisc
  sudo apt-get -y install gcc make git autoconf automake libtool python perl patch
  sudo apt-get -y install net-tools
  sudo apt-get -y install grub-common
  ln -s /usr/bin/env /bin/env
  apt-get -y install liblua5.2-dev
  apt-get -y install libpcap-dev
  apt-get -y install libncurses5-dev libncursesw5-dev
  apt-get -y install libedit-dev

  # Install dependencies for OVS (for SUT server only)
  sudo apt-get -y install python-devel openssl-devel kernel-debug-devel graphviz

  # Install dependencies for QEMU and VMs (for SUT server only)
  sudo apt-get -y install libglib2.0-dev
  sudo apt-get -y install libnuma-dev
  sudo apt-get -y install libvirt-bin
  sudo apt-get -y install libvirt-dev
  sudo apt-get -y install bridge-utils

  # Install dependencies for CRUCIO-DATS (for TG server only)
  sudo apt-get -y install gnuplot python-docutils
  sudo apt-get -y install rst2pdf
  sudo apt-get -y install python-pip
  # Update PIP packages
  pip install --upgrade pip
  pip install --upgrade setuptools
  pip install BeautifulSoup4
fi
