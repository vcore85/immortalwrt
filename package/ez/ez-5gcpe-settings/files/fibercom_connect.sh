#!/bin/sh

sleep 10
usbid=`lsusb | grep -i '2cb7' | awk '{print $6}'`
usbid_fm350=`lsusb | grep -i '0e8d' | awk '{print $6}'`

if [ -n "$usbid" ]; then      
        if [ "$usbid" = "2cb7:0105" ]; then
            sms_tool -d /dev/ttyUSB2 at 'AT+GTAUTODHCP=1'
            sleep 1
            sms_tool -d /dev/ttyUSB2 at 'AT+GTAUTOCONNECT=1'
            sleep 1
            sms_tool -d /dev/ttyUSB2 at 'at+GTIPPASS=1'
            sleep 1
            sms_tool -d /dev/ttyUSB2 at 'AT+GTRNDIS=1,1'
            sleep 20
            while true
                do  
                    if [ -z "$(sms_tool -d /dev/ttyUSB2 at 'AT+GTRNDIS?' | grep -o -E '0\.0\.0\.0')" ]; then
                        echo "FM150-AE has IP address"
                        sleep 15
                        continue
                    else
                        echo "FM150-AE no IP address"
                        sms_tool -d /dev/ttyUSB2 at 'AT+GTRNDIS=0,1'
                        sleep 5
                        sms_tool -d /dev/ttyUSB2 at 'AT+GTRNDIS=1,1'
                        sleep 20
                        logger -t fibercom_connect.sh "FM150-AE reconnect"
                    fi
             done
        elif [ "$usbid" = "2cb7:0a05" ]; then
            echo "FM650-CN"
			sms_tool -d /dev/ttyUSB0 at 'AT+GTAUTODHCP=1'
			sleep 1
			sms_tool -d /dev/ttyUSB0 at 'AT+GTAUTOCONNECT=1'
			sleep 1
			sms_tool -d /dev/ttyUSB0 at 'at+GTIPPASS=1'
			sleep 1
            sms_tool -d /dev/ttyUSB0 at 'AT+GTRNDIS=1,1'
            sleep 20
            while true
                do  
                    if [ -z "$(sms_tool -d /dev/ttyUSB0 at 'AT+GTRNDIS?' | grep -o -E '0\.0\.0\.0')" ]; then
                        echo "FM650 has IP address"
                        sleep 15
                        continue
                    else
                        echo "FM650 no IP address"
                        sms_tool -d /dev/ttyUSB0 at 'AT+GTRNDIS=0,1'
                        sleep 5
                        sms_tool -d /dev/ttyUSB0 at 'AT+GTRNDIS=1,1'
                        sleep 20
                        logger -t fibercom_connect.sh "FM650 reconnect"
                    fi
             done
        else
            echo "Unknown"
        fi
		sleep 15    
fi

if [ -n "$usbid_fm350" ]; then	
	if [ "$usbid_fm350" = "0e8d:7127" ]; then
		echo "FM350-GL"
        uci set network.5g.device='eth1'
		uci set network.5g.proto='static'
		uci set network.5g.ipaddr=''
		uci set network.5g.gateway=''
        uci set network.5g.netmask='255.255.255.0'
        uci del_list network.5g.dns='114.114.114.114'
        uci del_list network.5g.dns='223.5.5.5'
		uci add_list network.5g.dns='114.114.114.114'
		uci add_list network.5g.dns='223.5.5.5'
		uci commit network
        sms_tool -d /dev/ttyUSB0 at 'AT+CGDCONT=1,"IPV4V6","",,0,0,0,0,0,0,0'
        sleep 1
		while true
			do
			sleep 5
			ip_address=$(sms_tool -d /dev/ttyUSB0 at 'AT+CGPADDR=1' | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
			sleep 1
            if [ -n "$ip_address" ]; then
                ip_addr_uci=$(uci get network.5g.ipaddr)
                if [ "$ip_address" != "$ip_addr_uci" ]; then
                    ip_gw=$(echo $ip_address | awk -F. '{print $1"."$2"."$3".1"}')
                    uci set network.5g.ipaddr=$ip_address
                    uci set network.5g.gateway=$ip_gw
                    uci commit network
                    ifdown 5g
                    sleep 2
                    ifup 5g
                fi 
            else
                sms_tool -d /dev/ttyUSB0 at 'AT+CGDCONT=1,"IPV4V6","",,0,0,0,0,0,0,0'
                sleep 1
                sms_tool -d /dev/ttyUSB0 at 'AT+CGACT=1,1'
                sleep 2
            fi
		done
	fi
fi




