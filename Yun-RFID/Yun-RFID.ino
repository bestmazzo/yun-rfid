#include <PubSubClient.h>
#include <SeeedRFIDLib.h>
#include <YunClient.h>
#include <Console.h>
#include <SoftwareSerial.h>

#define DEBUG

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
char tgd[16];
  
void setup() {
  Bridge.begin();
#ifdef DEBUG  
  Console.begin();
#endif  
 checkConnection();
}

void loop() { 
  checkConnection(); 

  if(RFID.isIdAvailable()) {
    tag = RFID.readId();
    String s= String(tag.id);
    s.toCharArray(tgd, 16);
#ifdef DEBUG
    Console.print("ID: ");
    Console.println(tgd);
#endif    
    if (!mqtt.publish(MQTT_PUB_CHANNEL, tgd)){
#ifdef DEBUG      
      Console.println("ERROR");
#endif      
    }
  }
  delay(50);
}

void callback(char* topic, byte* payload, unsigned int length) {
  // handle received messages
#ifdef DEBUG 
  Console.println(topic);
  for (int i=0; i<length;i++){
    Console.print((char) payload[i]);
  }
  Console.println();
#endif
  
}

void checkConnection(){
  while (!mqtt.loop()){
     mqtt.connect(MQTT_CLIENTID);

     if (mqtt.connected()){       
        mqtt.subscribe(MQTT_SUB_CHANNEL);
#ifdef DEBUG  
        Console.println("Connected");     
     } else {   
        Console.println("Not connected yet");
#endif    
     }
     
     delay(2000);
  }
}

