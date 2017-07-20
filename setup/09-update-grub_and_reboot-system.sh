#!/bin/sh

ISOLCORES=$1
HUGEPAGESZ=$2
HUGEPAGES=$3

path="$(pwd)"
#source $path/env.sh

cores=$ISOLCORES
echo "====================================================="
echo "The following logical cores are setup for NICs usage:"
echo "====================================================="
echo $cores
echo "====================================================="
sed -i -e "/^GRUB_CMDLINE_LINUX/c\GRUB_CMDLINE_LINUX=\"\"" /etc/default/grub
sed -i -e "/^GRUB_CMDLINE_LINUX/ s/\"\$/ quiet default_hugepagesz=$HUGEPAGESZ hugepagesz=$HUGEPAGESZ hugepages=$HUGEPAGES\"/" /etc/default/grub
sed -i -e "/^GRUB_CMDLINE_LINUX/ s/\"\$/ isolcpus=$cores\"/" /etc/default/grub
sed -i -e "/^GRUB_CMDLINE_LINUX/ s/\"\$/ console=ttyS1,115200n8 noirqbalance\"/" /etc/default/grub
cat /etc/default/grub

update-grub
