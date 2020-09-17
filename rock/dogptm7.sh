#!/bin/bash
BOOTSIZE=128
CONFIGSIZE=16
USERNUM=${1}
SIZE1=${2}
SIZE2=${3}
DTB=${4}
COMPRESSED=${5}
IMAGE=${6}
STORE_APP=${7}

KERNEL="arch/arm64/boot/Image"
BOOTDIR="../../Bootloaders/u-boot-novasomM7-2020-07"
KERNELDIR="../../Kernels/linux-4.4.167_M7"
DEPLOYDIR="../../Deploy"

PART1START=0
PART1END=0
PART2START=0
PART2END=0
PART3START=0
PART3END=0
PART4START=0
PART4END=0

HERE="/Devel/NOVAsdk/Utils/rock"
. ${HERE}/../functions.sh

PARTED_CMD="sudo /usr/sbin/parted"

if [ -z ${IMAGE} ]; then
	IMAGE="/Devel/NovaSDK/Deploy/gpt.img"
fi
DD_BLOCKSIZE=16

let GPTSIZE=${BOOTSIZE}+${CONFIGSIZE}
if ! [ -z ${SIZE1} ]; then 
	let GPTSIZE=${BOOTSIZE}+${CONFIGSIZE}+${SIZE1}
fi
if ! [ -z ${SIZE2} ]; then 
	let GPTSIZE=${BOOTSIZE}+${CONFIGSIZE}+${SIZE1}+${SIZE2}
fi
let GPTSIZE=${GPTSIZE}+2
let DD_COUNT=${GPTSIZE}/${DD_BLOCKSIZE}
let DD_COUNT=${DD_COUNT}+1

function mkpart(){
	echo "${PARTED_CMD} -s ${IMAGE} -- unit s mkpart ${1} ${2} ${3}"
	${PARTED_CMD} -s ${IMAGE} -- unit s mkpart ${1} ${2} ${3}
}

echo "Creating a ${GPTSIZE} Mbytes image in ${IMAGE}"
dd if=/dev/zero of=${IMAGE} bs=${DD_BLOCKSIZE}M count=${DD_COUNT} status=progress
echo "Done"
${PARTED_CMD} -s ${IMAGE} mklabel gpt

echo "Partitioning"

let START=(1024*1024*16)/512
let END=(1024*1024*${BOOTSIZE}-1)/512
mkpart "boot" ${START} ${END}
${PARTED_CMD} -s ${IMAGE} set 1 boot on
PART1START=${START}
PART1END=${END}

let START=${END}+1
let END=(1024*1024*${CONFIGSIZE}-1)/512
let END=${END}+${START}
mkpart "config" ${START} ${END}
PART2START=${START}
PART2END=${END}

if [ "${USERNUM}" == "1" ]; then
	let START=${END}+1
	let END=(1024*1024*${SIZE1}-1)/512
	let END=${END}+${START}
	mkpart "user1" ${START} ${END}
	PART3START=${START}
	PART3END=${END}
fi

if [ "${USERNUM}" == "2" ]; then
        let START=${END}+1
        let END=(1024*1024*${SIZE1}-1)/512
        let END=${END}+${START}
        mkpart "user1" ${START} ${END}
	PART3START=${START}
	PART3END=${END}
        let START=${END}+1
        let END=(1024*1024*${SIZE2}-1)/512
        let END=${END}+${START}
        mkpart "user2" ${START} ${END}
	PART4START=${START}
	PART4END=${END}
fi
mkimage -C none -A arm -T script -d boot-novasom-m9.cmd ${DEPLOYDIR}/boot.scr

echo "Done"
echo "Formatting"
FAKEDISK="/tmp/mdisk"
LOOPDEV=`sudo losetup --partscan --show --find ${IMAGE}`
if [ "$?" == "0" ]; then
	sudo mke2fs -q -F -t ext4 -L boot ${LOOPDEV}p1
	sudo mke2fs -q -F -t ext4 -L config ${LOOPDEV}p2
	if ! [ "${PART3START}" == "0" ]; then 
		sudo mke2fs -q -F -t ext4 -L user1 ${LOOPDEV}p3
	fi
	if ! [ "${PART4START}" == "0" ]; then 
		sudo mke2fs -q -F -t ext4 -L user2 ${LOOPDEV}p4
	fi
	sudo dd if=${BOOTDIR}/idbloader.img of=${LOOPDEV} seek=64 status=progress
	sudo dd if=${BOOTDIR}/u-boot.itb of=${LOOPDEV} seek=16384 status=progress
	sudo rm -rf ${FAKEDISK} ; mkdir ${FAKEDISK}
	sudo mount ${LOOPDEV}p1 ${FAKEDISK}
	sudo mkdir ${FAKEDISK}/binfiles
	sudo cp ${BOOTDIR}/idbloader.img ${FAKEDISK}/binfiles
	sudo cp ${BOOTDIR}/u-boot.itb ${FAKEDISK}/binfiles
	sudo cp ${KERNELDIR}/.config ${FAKEDISK}/binfiles/m9.kernel.config
	sudo cp ${KERNELDIR}/${KERNEL} ${FAKEDISK}/Image
	sudo cp ${DEPLOYDIR}/m7_dtb.dtb ${FAKEDISK}/dtb.dtb
	sudo cp ${DEPLOYDIR}/uInitrd ${FAKEDISK}/.
	sudo cp ${DEPLOYDIR}/boot.scr ${FAKEDISK}/.
	echo "Files on microSD :"
	ls -la ${FAKEDISK}
	sudo umount ${FAKEDISK}
	if ! [ -z ${STORE_APP} ]; then
		echo "Storing ${STORE_APP} as application_storage"
		sudo mount ${LOOPDEV}p2 ${FAKEDISK}
		sudo mkdir ${FAKEDISK}/application_storage
		sudo cp -r ${STORE_APP}/* ${FAKEDISK}/application_storage/.
		sudo umount ${FAKEDISK}
	fi
	sudo losetup -d ${LOOPDEV}
	if [ "${COMPRESSED}" == "compressed" ]; then
		echo "Compressing ${IMAGE} to ${IMAGE}.bz2"
		cd ${DEPLOYDIR}
		rm -f ${IMAGE}.bz2
		bzip2 -k -9 ${IMAGE}	
	fi
else
	exit_if_error 1 "dogpt"
fi
exit_ok
