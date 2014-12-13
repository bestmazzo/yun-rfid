#!/bin/bash

CHANNEL="/it/bestmazzo/yun/rfid"
LEARN=0
UCI="uci -q"
#FUNCTION TO CALL ON MESSAGE RECEPTION
gotrfid(){
	RFID=$1

#	CHECK RFID EXISTENCE IN UCI
	$UCI get rfid.$1 -q > /dev/null
	if [ $? -eq 1 ]; then
		if [ $LEARN -eq 1 ]; then
			echo "Adding new ID $1"
			$UCI set rfid.$1=rfid
		else
			echo "ID $1 is not registered"
			return
		fi
	fi

#	CHECK RFID STATUS (IN/OUT/..)
	STATUS=`$UCI get rfid.$1.status`
      # echo "$1 -> $STATUS"

#	EXECUTE ACTIONS
	ACTIONS=`$UCI get rfid.$1.actions`


#	SET NEW RFID STATUS
	NEWSTATUS=in
	if [ $STATUS = "in" ]; then
		NEWSTATUS=out
	fi
	$UCI set rfid.$1.status=$NEWSTATUS

	echo "$1 -> $NEWSTATUS"
}



# READ MQTT CHANNEL
mosquitto_sub -t $CHANNEL | while read line
 do
  echo "LINE: $line"
  gotrfid $line
 done

