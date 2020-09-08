#!/bin/bash
echo "###### Customizing $2 file system ######"
cp -a board/novasis/NOVAsomM9/overlay/* ${TARGET_DIR}
chmod 777 ${TARGET_DIR}/bin/*
chmod 777 ${TARGET_DIR}/etc/init.d/*
IP=`hostname -I | awk '{print $1}'`
echo "REFERENCE_SERVER=${IP}" > board/novasis/NOVAsomM9/overlay/etc/sysconfig/system_vars
echo "FILE_SYSTEM_NAME=$2" > board/novasis/NOVAsomM9/overlay/etc/sysconfig/filesystem_name
exit $?
