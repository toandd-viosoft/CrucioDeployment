#!/bin/sh

path="$(pwd)"
#source $path/env.sh
# Get the name of NIC card, which can connect to internet
NET=$(route | grep '^default' | grep -o '[^ ]*$')
ipaddr=$(ifconfig $NET  | grep -ie "inet" | grep -ioEe "([0-9]+\.){3}[0-9]+")
ipaddr=($ipaddr)
IP=${ipaddr[0]}
#Shouldn't bind the NIC card which was being used to access internet, get its pci address
black_pci=(`ethtool -i $NET | grep bus-info | cut -d':' -f3-5`)
#black_pci=(`$RTE_SDK/tools/dpdk_nic_bind.py -s | grep Active |cut -d':' -f2-4`)
pci_port_type=(`lspci | grep Ether | grep $PCI_TYPE | cut -d' ' -f1`)
num_pci_ports=${#pci_port_type[@]}
#bind nic cards to dpdk driver
if [ $num_pci_ports -ge $NUMB_OF_PCI_PORTS ]
then
echo "Using igb_uio driver"
cd  $path

if [ $DPDK_DRIVER = igb_uio ]
then
lsmod |grep -w "^uio" >/dev/null 2>&1 || modprobe uio
lsmod |grep -w "^igb_uio" >/dev/null 2>&1 || insmod $RTE_SDK/$RTE_TARGET/kmod/igb_uio.ko
port=0
while [ $port -lt $NUMB_OF_PCI_PORTS ]
do
$RTE_BIND -u ${pci_port_type[$port]}
$RTE_BIND -b igb_uio ${pci_port_type[$port]}
port=`expr $port + 1`
done
$RTE_BIND --status
elif [ $DPDK_DRIVER = "vfio-pci" ]
then
echo "Using vfio-pci driver"
lsmod |grep -w "^uio" >/dev/null 2>&1 || modprobe vfio-pci
port=0
while [ $port -lt $NUMB_OF_PCI_PORTS ]
do
$RTE_BIND -u ${pci_port_type[$port]}
$RTE_BIND -b vfio-pci ${pci_port_type[$port]}
port=`expr $port + 1`
done
$RTE_BIND --status
else
echo "This driver is not supported by validium"
fi
else
echo "The number of ports is greater than real number of ports"
fi
