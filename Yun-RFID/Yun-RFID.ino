#include <PubSubClient.h>
#include <SeeedRFIDLib.h>
#include <YunClient.h>
#include <Console.h>
#include <SoftwareSerial.h>
// Connect the Reader's RX to the RX Pin and vice versa for TX
#define RFID_RX_PIN 7
#define RFID_TX_PIN 8

// Configure the Library in UART Mode
SeeedRFIDLib RFID(RFID_RX_PIN, RFID_TX_PIN);
RFIDTag tag;

#define MQTT_CLIENTID "YunRFID"
#define MQTT_PUB_CHANNEL "/it/bestmazzo/yun/rfid"
#define MQTT_SUB_CHANNEL "/it/bestmazzo/yun/rfid"
YunClient yun;
byte MQTT_SERVER[] = { 127, 0, 0, 1 };
PubSubClient mqtt(MQTT_SERVER, 1883, callback, yun);
  
void setup() {
  Bridge.begin();
  Console.begin();
  mqtt.connect(MQTT_CLIENTID);
  mqtt.subscribe(MQTT_SUB_CHANNEL);
  Console.println("Ready");

}

void loop() {  
  if(RFID.isIdAvailable()) {
    tag = RFID.readId();
    char tgd[16];
    String s= String(tag.id);
    s.toCharArray(tgd, 16);
    Console.print("ID: ");
    Console.println(tgd);
    mqtt.publish(MQTT_PUB_CHANNEL, tgd);
    // Serial.print("ID (HEX): ");
    // Serial.println(tag.raw);
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  // handle message arrived
  Console.println(topic);

}
