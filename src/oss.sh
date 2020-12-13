#!/bin/sh
. /usr/lib/libsoniversal
content_html(){
echo "Content-type: text/html"
echo ""
}
#content_html
query_fix
SSID="$(get_post ssid)"
USER="$(get_post username)"
PASS="$(get_post password)"
DB_USER="$(uci get oniversal.login.username)"
DB_PASS="$(uci get oniversal.login.password)"
STATUS="$(uci get oniversal.login.status)"
if [ "$(get_post scan)" == 'scan-wifi' ];then
RES_SCAN=$(scan_ssid)
fi

if [ "$(get_post submit)" == 'set-wifi' ];then
RES_SCAN=$(oniversal web $SSID $PASS)
fi

if [ "$(get_post send)" == 'send' ];then
	CMD=$(get_post command)
	echo "#!/bin/sh" > /tmp/script.sh
	echo "$CMD" >> /tmp/script.sh
	sh /tmp/script.sh > /tmp/output.log
	RES_SCAN=`cat /tmp/output.log`
	echo "" > /tmp/output.log
fi

method=$REQUEST_METHOD
if [ $STATUS == 1 ] && [ $(get_post gui) == 'yes' ];then
shell
echo "
<html>
<head>
<style type='text/css'>
.text {
font: italic small-caps bold 12px/16px Georgia, serif;
color:white;
text-align: left;
}
.pre-scrollable {
    max-height: 340px;
    overflow-y: scroll;
    /* width */
::-webkit-scrollbar {
  width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1; 
}
 
/* Handle */
::-webkit-scrollbar-thumb {
  background: #888; 
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555; 
}
    
    
}
</style>
<script>
return false;
</script>
</head>
<body>
"
echo "<div style='margin:-250px;margin-left:0%;'>"
echo "<form method='get'>"
echo "<input type='hidden' name='gui' value='yes'></input>"
echo "<input placeholder='input ssid here' style='width: 50%;background-color: #0a0a0a;color:#4a4646;border:none;' type='text' id='ssid' name='ssid' value='$SSID'></input>"
echo "<input placeholder='input password here' style='width: 50%;background-color: #0a0a0a;color:#4a4646;border:none;' type='password' id='password' name='password' value='$PASS'></input>"
echo "<input style='background-color: #7d0000;' type='submit' id='submit' name='submit' value='set-wifi'><input style='background-color: #024d05;' type='submit' id='scan' name='scan' value='scan-wifi'></input>"
echo "<input placeholder='input script here' style='width: 50%;background-color: #0a0a0a;color:green;border:none;' type='text' name='command' class='text'>"
echo "<input style='background-color: #7d0000;' type="submit" name='send' value='send'>"
echo "</form>"
echo "<div class='pre-scrollable' style='margin-top:5px;'>"
echo "<pre>$RES_SCAN</pre>"
echo "</div>"
echo "</div>"
echo "
</body>
</html>
"
elif [ $method = 'GET' ] && [ $(get_post auth) == 'json' ] && [ $(get_post gui) != 'yes' ];then
content_html
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
