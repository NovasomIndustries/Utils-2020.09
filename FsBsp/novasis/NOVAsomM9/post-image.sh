#!/bin/bash

echo "###### Creating $2 uInitrd for NOVAsomM9 ######"
output/host/usr/bin/mkimage -A arm -O linux -T ramdisk -C gzip -n "$2" -a 0x80000 -d output/images/rootfs.ext3.gz output/images/uInitrd
rm -f ../../Deploy/uInitrd
ln -s ${BASE_DIR}/images/uInitrd -t ../../Deploy
exit $?
