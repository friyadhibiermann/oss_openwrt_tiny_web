#!/bin/sh
_DEV=`block info | grep ext4 | awk -F':' '{print $1}' | cut -d'/' -f3`
exroot(){
clear
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
PING=`which ping`

function waitForHost
{
    if [ -n "$1" ];
    then
        waitForHost1 $1 > /dev/null 2>&1
                echo "Internet Connected"
    else
        echo -n "..."
    fi
}

function waitForHost1
{
    reachable=0;
    while [ $reachable -eq 0 ];
    do
    $PING -q -c 1 $1
    if [ "$?" -eq 0 ];
    then
        reachable=1
    fi
    done
    sleep 5
}
config_network(){
        conf_dir="/etc/config"
        config="network"
        uci set network.wlan=interface
        uci set network.wlan.netmask='255.255.255.0'
        uci set network.wlan.proto='dhcp'
        uci commit $config
		uci set firewall.cfg04dc81.network=lan
		uci set firewall.cfg06dc81.network='wan wan6 wlan'
		uci commit firewall
        /etc/init.d/network restart
        wifi up
        waitForHost google.com
}
config_wireless(){
        read -p "SSID: " SSID
        read -p "KEY: " KEY
        conf_dir="/etc/config"
        config="wireless"
        rm -rf $conf_dir/$config
        wifi config
        sed -i 's/default_radio0/ap/' $conf_dir/$config
        uci -q set wireless.ap.ssid='FDI-LEDE'
        uci -q set wireless.ap.encryption=psk2
        uci -q set wireless.ap.key='1234567890'
        uci commit $config
        if [ "$SSID" != "" -o "$KEY" != "" ];then
			uci -q set wireless.sta=wifi-iface
			uci -q set wireless.sta.network='wlan'
			uci -q set wireless.sta.encryption='psk2'
			uci -q set wireless.sta.device='radio0'
			uci -q set wireless.sta.mode='sta'
			uci -q set wireless.sta.key="$KEY"
			uci -q set wireless.sta.ssid="$SSID"
			uci -q set wireless.radio0.disabled='0'
			uci commit $config
			config_network
		fi
}
help(){
echo "1.) fdi exroot"
echo "2.) fdi update-script"
echo "3.) fdi ap-sta wifi auto set"
echo "4.) fdi install luci"
}
help
read -p "masukan pilihan [1-2] :" opt
case $opt in
        '1')
                exroot
        ;;
        '2')
                _host="http://felexindo.mooo.com"
                ping -w 1 felexindo.mooo.com
                if [ $? == 0 ];then
                        cd /tmp && rm -rf fdi && wget --quiet $_host\:81/script/fdi
                        cat /tmp/fdi > /usr/bin/fdi
                else
                        echo "maaf script belum relase atau periksa kembali koneksi anda"
                fi
        ;;
        '3')
				config_wireless $2 $3
        ;;
	'4')
		echo "update.."
		cd /tmp && opkg update > /dev/null 2>&1
		echo "install luci..."
		opkg install luci ca-bundle ca-certificates libustream-openssl  > /dev/null 2>&1
		echo "install luci-theme-darkmatter"
		wget https://apollo.open-resource.org/downloads/luci-theme-darkmatter_0.2-beta-2_all.ipk  > /dev/null 2>&1
		opkg install luci-theme-darkmatter_0.2-beta-2_all.ipk  > /dev/null 2>&1
		cd ~/
	;;
esac
