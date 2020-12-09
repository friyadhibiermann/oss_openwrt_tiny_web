#!/bin/sh
exroot(){
	clear
	_DEV=`block info | grep ext4 | awk -F':' '{print $1}' | cut -d'/' -f3`
	_FREE_SPACE=`df -hm | grep '/overlay' | awk '{print $4}' | tail -1`
	_STAT_EX=$(df -h | grep "$_DEV" | wc -l)
	if [ "$_STAT_EX" == 1 ];then
        	echo "router sudah di exroot space = $_FREE_SPACE"
	else
        	if [ "`echo $_DEV | wc -l`" -ge '1' ];then
                	echo "preosess exroot..."
                	mount /dev/$_DEV /mnt ; tar -C /overlay -cf - . | tar -C /mnt -xf - ; umount /mnt
                	echo "selesai..."
                	block detect > /etc/config/fstab; \
                	sed -i s/option$'\t'enabled$'\t'\'0\'/option$'\t'enabled$'\t'\'1\'/ /etc/config/fstab; \
                	sed -i s#/mnt/$_DEV#/overlay# /etc/config/fstab
                	mount /dev/$_DEV /overlay
                	echo "exroot mount /dev/$_DEV"
        	else
                	echo "flashdisk dengan format ext4 belum terbaca"
        	fi
	fi
}

function waitForHost
{
    if [ -n "$1" ];
    then
        waitForHost1 $1 
                printf "\nInternet Connected\n"
    else
        echo -n "..."
    fi
}

function waitForHost1
{
    reachable=0;
    while [ $reachable -eq 0 ];
    do
    $PING -q -c 1 $1 > /dev/null 2>&1
    if [ "$?" -eq 0 ];
    then
        reachable=1
	else
		IP=$(ifconfig | awk '/wlan0/,/inet/' | grep inet | awk -F' ' '{print $2}' | grep [0-9])
		echo -n "▀"
		sleep 1
    fi
    done
    sleep 5
}
config_network(){
        conf_dir="/etc/config"
        config="network"
        uci -q set network.wlan=interface
        uci -q set network.wlan.netmask='255.255.255.0'
        uci -q set network.wlan.proto='dhcp'
        uci commit network
	uci -q set firewall.cfg04dc81.network=lan
	uci -q set firewall.cfg06dc81.network='wan wan6 wlan'
	uci commit firewall
	/etc/init.d/firewall restart > /dev/null 2>&1
        waitForHost google.com
	wifi up
	/etc/init.d/network restart > /dev/null 2>&1
}
config_wireless(){
        read -p "SSID: " SSID
        read -p "KEY: " KEY
        conf_dir="/etc/config"
        config="wireless"
        rm -rf $conf_dir/$config
        wifi config
		sed -i 's/default_radio0/ap/' $conf_dir/$config
		uci -q set wireless.ap.ssid='ONIVERSAL-OSS'
		uci -q set wireless.ap.encryption='psk2'
		uci -q set wireless.ap.key='admin'
		uci commit wireless
        if [ "$SSID" != "" -o "$KEY" != "" ];then
		uci set wireless.radio0.disabled='0'
		uci set wireless.sta='wifi-iface'
		uci set wireless.sta.network='wlan'
		uci set wireless.sta.encryption='psk2'
		uci set wireless.sta.device='radio0'
		uci set wireless.sta.mode='sta'
		uci set wireless.sta.key="$KEY"
		uci set wireless.sta.ssid="$SSID"
		uci commit wireless
		config_network
	fi
}

help(){
	echo "1.) fdi exroot"
	echo "2.) fdi ap-sta wifi auto set"
}
base_script(){
rm /etc/config/wireless > /dev/null 2>&1
wifi config
uci set wireless.radio0.disabled='0'
uci commit wireless
wifi up
	help
	read -p "masukan pilihan [1-2] :" opt
	case $opt in
		'1')
	    	exroot
		;;
		'2')
			echo "list:"
			echo "################"
			iw wlan0 scan | grep SSID | awk -F':' '{print $2}' | sed -e 's/^\ *//'
			echo "################"
			config_wireless $2 $3
		;;
	esac
}
base_script
