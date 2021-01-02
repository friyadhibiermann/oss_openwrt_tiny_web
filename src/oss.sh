#!/bin/sh
. /usr/lib/libsoniversal
query_fix
USER="$(get_post username)"
PASS="$(get_post password)"
DB_USER="$(uci get oniversal.login.username)"
DB_PASS="$(uci get oniversal.login.password)"
STATUS="$(uci get oniversal.login.status)"
method=$REQUEST_METHOD
content_html
if [ $STATUS == 1 ];then
if [ "$(get_post kirim)" == 'kirim' ];then
        CMD=$(get_post command)
        echo "#!/bin/sh" > /tmp/script.sh
        echo "$CMD" >> /tmp/script.sh
        sh /tmp/script.sh > /tmp/output.log
        RES_SCAN="<div>`cat /tmp/output.log`</div>"
        echo "" > /tmp/output.log
fi
if [ "$(get_post wifi-set)" == 'set-wifi' ];then
        PASSWORD="$(get_post pass)"
        SSID="$(get_post ssid)"
        RES_SCAN=$(oniversal web $SSID $PASSWORD)
        _head
        first_view
        result
        footer
        exit 0
fi
if [ "$(get_post scan)" == 'scanwifi' ];then
        RES_SCAN=`printf "SSID:\n$(scan_ssid)"`
        _head
        first_view
        wifi_scaner
        result
        footer
fi

if [ "$(get_post shell_gui )" == "cli Web Gui" ];then
        CMD=$(get_post command)
        _head
        first_view
        shell_gui
        result
        footer
fi
if [ "$(get_post openwifisetting)" == 'setting wifi' ];then
        _head
        first_view
        wifi_setting
        result
        if [ "$(get_post wifi-set)" == 'set-wifi' ];then
                PASSWORD="$(get_post pass)"
                SSID="$(get_post ssid)"
                RES_SCAN=$(oniversal web $SSID $PASSWORD)
                break

        fi
        footer
fi
if [ "$(get_post dev-info)" == "Device Information" ];then
        _head
        first_view
        RES_SCAN=$(shell)
        result
        footer
fi
if [ "$(get_post openfirewall)" == "firewall config" ];then
        LIST="$(ifconfig -a | sed 's/[ \t].*//;/^$/d')"
        _head
        first_view
        _html_iptables
        footer
fi

if [ "$(get_post logout)" == "logout" ];then
        uci set oniversal.login.status='0'
        uci commit oniversal
        echo '<meta http-equiv="refresh" content="1;url=/" />'
fi
fi
if [ $method = 'GET' ] && [ $STATUS == 1 ] && [ $(get_post gui) == 'yes' ];then
_head
echo "$(first_view)"
echo "$(result)"
footer
elif [ $method = 'GET' ] && [ $(get_post auth) == 'json' ] || [ $(get_post gui) != 'yes' ];then
        if [ $DB_USER == $USER ] && [ $DB_PASS == $PASS ];then
                uci set oniversal.login.status='1'
                uci commit oniversal
                STATUS="$(uci get oniversal.login.status)"
                DATA="{\"success\":\"$STATUS\",\"username\":\"$USER\",\"password\":\"$PASS\"}"
                echo $DATA
        elif [ $DB_USER != $USER ] || [ $DB_PASS != $PASS ];then
                ERROR=$(echo "error password dan user tidak cocok")
                uci set oniversal.login.status='0'
                uci commit oniversal
                STATUS="$(uci get oniversal.login.status)"
                DATA="{\"error\":\"$ERROR\",\"username\":\"$USER\",\"password\":\"$PASS\"}"
                echo $DATA
        fi
elif [ $STATUS == 0 ];then
        echo "silahkan login terlebih dahulu"
fi
