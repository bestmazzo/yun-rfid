#!/bin/bash

UCI="uci -q"
DEFCHANNEL="/it/bestmazzo/yun/rfid"
CHANNEL=`$UCI get rfid.default.inchannel`

getAction(){
	TMP=`$UCI get $1`
	echo "TMP: $TMP"
	ACTIONS=`$UCI get rfid.$TMP.actions -d ' ; '`
	echo "ACTIONS: $ACTIONS"
        $ACTIONS > /dev/null
}
#FUNCTION TO CALL ON MESSAGE RECEPTION
gotrfid(){

#	CHECK RFID EXISTENCE IN UCI
	$UCI get rfid.$1 > /dev/null
	if [ $? -eq 1 ]; then
		LEARN=`$UCI get rfid.default.learn`
		if [ $LEARN -eq 1 ]; then
			echo "Adding new ID $1"
			$UCI set rfid.$1=rfid
	              # CALL ADD ACTION
                        getAction rfid.default.onadd
		else
			echo "ID $1 is not registered and autolearn is off"
		      # CALL ERROR ACTION
			getAction rfid.default.onerror
			return
		fi
		
	fi

#	CHECK RFID STATUS (IN/OUT/..)
	SYSMODE=`$UCI get rfid.default.sysmode`
	RFID=$1

	case $SYSMODE in
        "GLOBAL")
		RFID="default"
		;;
	"SINGLE")
		RFID=$1
		;;
	"HYBRID")
		;;
	esac

	STATUS=`$UCI get rfid.$RFID.status`
      # echo "$1 -> $STATUS"

#	SET NEW RFID STATUS
	NEWSTATUS=in
	if [ $STATUS = "in" ]; then
		NEWSTATUS=out
	fi
	$UCI set rfid.$RFID.status=$NEWSTATUS
	echo "$RFID -> $NEWSTATUS"

#       EXECUTE ACTIONS
        getAction rfid.$RFID.$NEWSTATUS
}

# READ MQTT CHANNEL
mosquitto_sub -t $CHANNEL | while read line
 do
  echo "LINE: $line"
  gotrfid $line
 done
