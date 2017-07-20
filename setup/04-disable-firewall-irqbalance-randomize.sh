#!/bin/sh

YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

if [ "$APT_GET_CMD" != "" ]; then
  service irqbalance stop
  echo 0 > /proc/sys/kernel/randomize_va_space
elif [ "$YUM_CMD" != "" ]; then
  sudo service iptables save
  sudo systemctl stop firewalld
  sudo systemctl disable  firewalld
  sudo systemctl disable irqbalance.service
  echo 0 > /proc/sys/kernel/randomize_va_space
fi
