#!/bin/bash

UCI="uci -q"
DEFCHANNEL="/it/bestmazzo/yun/rfid"
CHANNEL=`$UCI get rfid.default.inchannel`

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
                        ONADD=`$UCI get rfid.default.onadd -d ' ; '`
			echo "ADD ACTIONS: $ONADD"
                        $ONADD > /dev/null
		else
			echo "ID $1 is not registered and autolearn is off"
		      # CALL ERROR ACTION
			ONERROR=`$UCI get rfid.default.onerror -d ' ; '`
			echo "ERROR ACTIONS: $ONERROR"
			$ONERROR > /dev/null
			return
		fi
		
	fi

#	CHECK RFID STATUS (IN/OUT/..)
	SYSMODE=`$UCI get rfid.default.sysmode`
	RFID=$1
	if [ $SYSMODE = "GLOBAL" ]; then
		RFID="default"
	fi
	STATUS=`$UCI get rfid.$RFID.status`
      # echo "$1 -> $STATUS"

#	SET NEW RFID STATUS
	NEWSTATUS=in
	if [ $STATUS = "in" ]; then
		NEWSTATUS=out
	fi
	$UCI set rfid.$RFID.status=$NEWSTATUS
	
	echo "$TMPID -> $NEWSTATUS"

#       EXECUTE ACTIONS
        ACTIONS=`$UCI get rfid.$RFID.$NEWSTATUS -d ' ; '`
        echo "$? Executing $ACTIONS"
        $ACTIONS > /dev/null

}

# READ MQTT CHANNEL
mosquitto_sub -t $CHANNEL | while read line
 do
  echo "LINE: $line"
  gotrfid $line
 done
