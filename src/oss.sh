#!/bin/sh
. /usr/lib/libsoniversal
query_fix
USER="$(get_post username)"
PASS="$(get_post password)"
DB_USER="$(uci get oniversal.login.username)"
DB_PASS="$(uci get oniversal.login.password)"
STATUS="$(uci get oniversal.login.status)"
content_html
if [ "$(get_post kirim)" == 'kirim' ];then
        CMD=$(get_post command)
        echo "#!/bin/sh" > /tmp/script.sh
        echo "$CMD" >> /tmp/script.sh
        sh /tmp/script.sh > /tmp/output.log
        RES_SCAN=`cat /tmp/output.log`
        echo "" > /tmp/output.log
fi
if [ "$(get_post wifi-set)" == 'set-wifi' ];then
        PASSWORD="$(get_post pass)"
        SSID="$(get_post ssid)"
        RES_SCAN=$(oniversal web $SSID $PASSWORD)
        head
        shell
        first_view
        result
        footer
        exit 0
fi
if [ "$(get_post scan)" == 'scanwifi' ];then
        RES_SCAN=`printf "SSID:\n$(scan_ssid)"`
        head
        shell
        first_view
        wifi_scaner
        result
        footer
fi

if [ "$(get_post shell_gui )" == "cli Web Gui" ];then
        CMD=$(get_post command)
        head
        shell
        first_view
        shell_gui
        result
        footer
fi
if [ "$(get_post openwifisetting)" == 'setting wifi' ];then
        head
        shell
        wifi_setting
        result
        footer
        if [ "$(get_post wifi-set)" == 'set-wifi' ];then
                PASSWORD="$(get_post pass)"
                SSID="$(get_post ssid)"
                RES_SCAN=$(oniversal web $SSID $PASSWORD)
                break

        fi
fi
method=$REQUEST_METHOD
if [ $STATUS == 1 ] && [ $(get_post gui) == 'yes' ];then
head
shell
first_view
result
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
fi
