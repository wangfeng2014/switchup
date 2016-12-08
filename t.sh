#!/bin/sh

set -o nounset
set -o errexit
#set -x 
IPTABLES_WIFI=./iptables_wifi
IPTABLES_4G=./iptables_4g
INTERFACES_WIFI=./interfaces_wifi
INTERFACES_4G=./interfaces_4g


[ -s "$IPTABLES_WIFI" ] || { echo 'missing file iptables_wifi'; exit 0; }
[ -s "$IPTABLES_4G" ] || { echo 'missing file iptables_4g' ; exit 0; }
[ -s "$INTERFACES_WIFI" ] || { echo 'missing file interfaces_wifi' ; exit 0;}
[ -s "$INTERFACES_4G" ] || { echo 'missing file interfaces_4g' ; exit 0;}

getmode () {  
        apflag=$(ps -ef|grep hostapd |grep  -v grep |awk '{print $2}')
        
        if [ -n "$apflag" ];then
            echo "4g" 
        else 
            echo "wifi" 
        fi
}

showusage () {
        mode=$(getmode)
        echo "Current mode is :$mode"
        echo 
        echo "Usage: $0 {wifi|4g}" >&2
}

if [ "$#" -lt 1 ]; then
    showusage
    exit 1
fi

case "$1" in
  wifi)
        sudo insserv -v -r /etc/init.d/hostapd
        sudo cp $INTERFACES_WIFI /etc/network/interfaces
        sudo cp $IPTABLES_WIFI   /etc/sysconfig/iptables
        sync
        echo 'switch to mode : wifi'
        echo 'now , need reboot the system to apply the config'
	    ;;
  4g)
        sudo insserv -v  /etc/init.d/hostapd
        sudo cp $INTERFACES_4G /etc/network/interfaces
        sudo cp $IPTABLES_4G   /etc/sysconfig/iptables
        sync
        echo 'switch to mode : 4G'
        echo 'now , need reboot the system to apply the config'
	    ;;
  mode)
        echo $(getmode)
        ;;
  *)
        showusage
	    exit 1
        ;;
 esac

exit 0


