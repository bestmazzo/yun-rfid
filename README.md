#Yun-RFID

An Arduino Yun project for reading RFID tags and doing things - all wrapped in [MQTT][MQTT]!

#ABOUT

This project is about creating a little and hopefully not so shortsighted DIY solution for reading RFID tags with a Arduino and manage subsequent actions. The aim is to create a standalone solution that could be easily integrated in a wider environment, thus allowing end-user to quickly make it work almost out-of-the-box, while letting developers extending it with a little extra effort.

Every code review, suggestion and reuse of current code is welcome!

###UNDER THE HOOD
Software architecture is based on MQTT protocol.
* Yun OpenWRT hosts a [Mosquitto] MQTT server and some client scripts.
* Yun sketch reads [RFID][seeed rfid] tags and publish them on local server over a certain channel. 
* Client scripts manage standalone operations
* Mosquitto could be configured in bridge mode (see [[1]][mosquitto bridge 1] or even [[2]][mosquitto bridge 2]), in order to share messages with another MQTT server, thus allowing every kind of extensions.

#REQUIRED HARDWARE
* Arduino [YUN][arduino yun]
* RFID Serial Reader (I used the Seeddstudio one) see [here][seeed rfid]
* Wires and so on...

[seeed rfid]:  http://www.seeedstudio.com/wiki/index.php?title=Electronic_brick_-_125Khz_RFID_Card_Reader
[arduino yun]: http://arduino.cc/en/Main/ArduinoBoardYun
[mosquitto]: http://www.mosquitto.org
[mosquitto bridge 1]: https://github.com/owntracks/owntracks/wiki/Bridge
[mosquitto bridge 2]: http://jpmens.net/2013/02/25/lots-of-messages-mqtt-pub-sub-and-the-mosquitto-broker/
[MQTT]: http://mqtt.org

#USAGE
TODO
