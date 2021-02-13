#!/bin/bash

TAG="#HACKED"

# hack /etc/hosts

grep -q "^$TAG" /etc/hosts
if [ "$1" != "0" ]
then
	cp /etc/hosts /etc/hosts_cp
	sed -i "1i$TAG" /etc/hosts_cp
	umount /etc/hosts
	cp /etc/hosts_cp /etc/hosts
fi

# hack /etc/hostname

cp /etc/hostname /etc/hostname_cp
umount /etc/hostname
cp /etc/hostname_cp /etc/hostname
