#!/bin/sh
. /etc/sysconfig/wireless
. /etc/sysconfig/network
cat /etc/wpa_supplicant.conf | grep your_ssid
if [ "$?" == "0" ]; then
	echo "Please fill /etc/wpa_supplicant.conf appropriately"
	echo -n "Enter SSID   : "
	read SSID
	echo -n "Enter PASSWD : "
	read PASSWD
	echo $SSID $PASSWD
	echo "# Generated by $0" > /etc/wpa_supplicant.conf
	echo "ctrl_interface=/var/run/wpa_supplicant" >> /etc/wpa_supplicant.conf
	echo "ctrl_interface_group=0" >> /etc/wpa_supplicant.conf
	echo "ap_scan=1" >> /etc/wpa_supplicant.conf
	echo "update_config=1" >> /etc/wpa_supplicant.conf
	echo "" >> /etc/wpa_supplicant.conf
	echo "network={" >> /etc/wpa_supplicant.conf
	echo "	ssid=\"$SSID\"" >> /etc/wpa_supplicant.conf
	echo "	psk=\"$PASSWD\"" >> /etc/wpa_supplicant.conf
	echo "	scan_ssid=1" >> /etc/wpa_supplicant.conf
	echo "	key_mgmt=WPA-EAP WPA-PSK IEEE8021X NONE" >> /etc/wpa_supplicant.conf
	echo "	pairwise=TKIP CCMP" >> /etc/wpa_supplicant.conf
	echo "	group=CCMP TKIP WEP104 WEP40" >> /etc/wpa_supplicant.conf
	echo "	priority=5" >> /etc/wpa_supplicant.conf
	echo "}" >> /etc/wpa_supplicant.conf

	mount /dev/mmcblk0p2 /mnt
	cp /etc/wpa_supplicant.conf /mnt/sysconfig/etc/wpa_supplicant.conf
	umount /mnt
	echo "wpa_supplicant.conf stored in permanent storage"
fi

ifconfig ${NET_DEVICE} down
# LED on lan connetor off
i2cset -f -y 1 0x18 0x52 2
killall udhcpc
killall wpa_supplicant
sleep 1
wpa_supplicant -Dnl80211 -i${WLAN_DEVICE} -c/etc/wpa_supplicant.conf -B

if [ "${WLAN_USE_DHCP}" == "Y" ]; then
       udhcpc -i ${WLAN_DEVICE} &
else
       ifconfig ${WLAN_DEVICE} ${WLAN_IP_ADDRESS} up
       route add default gw ${WLAN_GATEWAY}
fi
