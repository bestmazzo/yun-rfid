#include <PubSubClient.h>
#include <SeeedRFIDLib.h>
#include <YunClient.h>
#include <Console.h>
#include <SoftwareSerial.h>

// Connect the RFID reader's RX to the RX Pin and vice versa for TX
#define RFID_RX_PIN 7
#define RFID_TX_PIN 8

// Define common MQTT data
#define MQTT_CLIENTID "YunRFID"
#define MQTT_PUB_CHANNEL "/it/bestmazzo/yun/rfid"
#define MQTT_SUB_CHANNEL "/it/bestmazzo/yun/rfid/conf"

// Configure the RFID Library in UART Mode
SeeedRFIDLib RFID(RFID_RX_PIN, RFID_TX_PIN);
RFIDTag tag;

// Configure mqtt library
YunClient yun;
byte MQTT_SERVER[] = { 127, 0, 0, 1 };
PubSubClient mqtt(MQTT_SERVER, 1883, callback, yun);

  
void setup() {
  Bridge.begin();
  Console.begin();
  while (!mqtt.connect(MQTT_CLIENTID)){
    Console.println("Not ready yet");
    delay(1000);
  }
  mqtt.subscribe(MQTT_SUB_CHANNEL);
  Console.println("Ready");

}

void loop() {  
  mqtt.loop();
  if(RFID.isIdAvailable()) {
    tag = RFID.readId();
    char tgd[16];
    String s= String(tag.id);
    s.toCharArray(tgd, 16);
    Console.print("ID: ");
    Console.print(tgd);
    if (!mqtt.publish(MQTT_PUB_CHANNEL, tgd)){
      Console.println(" ERROR");
    }
    // Serial.print("ID (HEX): ");
    // Serial.println(tag.raw);
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  // handle message arrived
  Console.println(topic);
  for (int i=0; i<length;i++){
    Console.print(payload[i]);
  }
  Console.println();

}
