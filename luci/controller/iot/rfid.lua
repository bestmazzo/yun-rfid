module("luci.controller.iot.rfid", package.seeall)

function index()
	entry({"admin","iot"},cbi("iot_rfid/config"), "RFID Config",30).dependent=false
end
