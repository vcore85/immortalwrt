#!/bin/sh

usbid=`lsusb | grep -i '2cb7' | awk '{print $6}'`
usbid_fm350=`lsusb | grep -i '0e8d' | awk '{print $6}'`

if [ "$usbid" = "2cb7:0105" ]; then
    echo "FM150-AE"
    uci set modemband.@modemband[0].set_port='/dev/ttyUSB2'
    uci set modemband.@modemband[0].modemid='2cb7:0105'
    uci commit modemband
    uci set 3ginfo.@3ginfo[0].device='/dev/ttyUSB2'
    uci commit 3ginfo
    uci set sms_tool_js.@sms_tool_js[0].atport='/dev/ttyUSB2'
    uci set sms_tool_js.@sms_tool_js[0].readport='/dev/ttyUSB2'
    uci set sms_tool_js.@sms_tool_js[0].sendport='/dev/ttyUSB2'
    uci set sms_tool_js.@sms_tool_js[0].ussdport='/dev/ttyUSB2'
    uci commit sms_tool_js
	uci set luci_statistics.collectd_interface.Interfaces='usb0'
	uci commit luci_statistics
	/etc/init.d/luci_statistics restart	
elif [ "$usbid" = "2cb7:0a05" ]; then
    echo "FM650-CN"
    uci set modemband.@modemband[0].set_port='/dev/ttyUSB0'
    uci set modemband.@modemband[0].modemid='2cb7:0a05'
    uci commit modemband
    uci set 3ginfo.@3ginfo[0].device='/dev/ttyUSB0'
    uci commit 3ginfo
    uci set sms_tool_js.@sms_tool_js[0].atport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].readport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].sendport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].ussdport='/dev/ttyUSB0'
    uci commit sms_tool_js
	uci set luci_statistics.collectd_interface.Interfaces='usb0'
	uci commit luci_statistics
	/etc/init.d/luci_statistics restart	
elif [ "$usbid_fm350" = "0e8d:7127" ]; then
    echo "FM350-GL"
    uci set modemband.@modemband[0].set_port='/dev/ttyUSB0'
    uci set modemband.@modemband[0].modemid='0e8d:7127'
    uci commit modemband
    uci set 3ginfo.@3ginfo[0].device='/dev/ttyUSB0'
    uci commit 3ginfo
    uci set sms_tool_js.@sms_tool_js[0].atport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].readport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].sendport='/dev/ttyUSB0'
    uci set sms_tool_js.@sms_tool_js[0].ussdport='/dev/ttyUSB0'
    uci commit sms_tool_js
	uci set luci_statistics.collectd_interface.Interfaces='eth1'
	uci commit luci_statistics
	/etc/init.d/luci_statistics restart
else
    echo "Unknown"
fi