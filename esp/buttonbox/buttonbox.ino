#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Network settings
const char* ssid = "beekmannen";
const char* password = "3030303030";

// PubSub settings
const char* mqtt_server = "192.168.0.55";
const char* topic = "components/buttonboxwhite/";

// Button settings
const int leftButton = 5;
bool leftButtonState = false;
bool leftButtonCurrent = false;

const int middleButton = 10;
bool middleButtonState = false;
bool middleButtonCurrent = false;

const int rightButton = 0;
bool rightButtonState = false;
bool rightButtonCurrent = false;

const bool pressed = false;

// Temperature
unsigned long previousMillis = 0;  // will store last time temp was read
const long interval = 30000;      // interval at which to read sensor

WiFiClient espClient;
PubSubClient client(espClient);

void setup_wifi() {
  delay(10);

  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    digitalWrite(BUILTIN_LED, HIGH);
    delay(250);
    digitalWrite(BUILTIN_LED, LOW);
    delay(250);
    Serial.print(".");
  }
  digitalWrite(BUILTIN_LED, LOW);
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ButtonBoxBlack")) {
      Serial.println("connected");
      digitalWrite(BUILTIN_LED, LOW);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      digitalWrite(BUILTIN_LED, LOW);
      delay(2500);
      digitalWrite(BUILTIN_LED, HIGH);
      delay(2500);
    }
  }
}

void setup() {
  pinMode(leftButton, INPUT_PULLUP);   // Initialize left button pullup
  pinMode(middleButton, INPUT_PULLUP); // Initialize middle button pullup
  pinMode(rightButton, INPUT_PULLUP);  // Initialize right button pullup

  pinMode(BUILTIN_LED, OUTPUT);        // Initialize the BUILTIN_LED pin as an output
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  leftButtonState = digitalRead(leftButton);
  if(leftButtonState != leftButtonCurrent) {
    if(leftButtonState == pressed) {
      char msg[2];
      sprintf(msg, "{}");
      char outputTopic[80];
      sprintf(outputTopic,"%sleftButton",topic);
      Serial.println(outputTopic);
      client.publish(outputTopic, msg);
    }
    leftButtonCurrent = leftButtonState;
  }

  middleButtonState = digitalRead(middleButton);
  if(middleButtonState != middleButtonCurrent) {
    if(middleButtonState == pressed) {
      char msg[2];
      sprintf(msg, "{}");
      char outputTopic[80];
      sprintf(outputTopic,"%smiddleButton",topic);
      Serial.println(outputTopic);
      client.publish(outputTopic, msg);
    }
    middleButtonCurrent = middleButtonState;
  }

  rightButtonState = digitalRead(rightButton);
  if(rightButtonState != rightButtonCurrent) {
    if(rightButtonState == pressed) {
      char msg[2];
      sprintf(msg, "{}");
      char outputTopic[80];
      sprintf(outputTopic,"%srightButton",topic);
      Serial.println(outputTopic);
      client.publish(outputTopic, msg);
    }
    rightButtonCurrent = rightButtonState;
  }

  unsigned long currentMillis = millis();

  // Check if <interval> seconds have passed, send the temperature
  if((currentMillis - previousMillis) >= interval) {
    // save the last time you read the sensor 
    previousMillis = currentMillis;   


    int reading = analogRead(A0);  
    float voltage = reading * 3.0;
    voltage /= 1024.0; 
    float temperature = (voltage - 0.5) * 100 ;
    Serial.print(temperature); Serial.println(" degrees C");
    String temp = String(temperature, DEC);
    char tempBuf[20];
    dtostrf(temperature, 0, 1, tempBuf);
    char msg[80];
    sprintf(msg, "{\"value\":%s}", tempBuf);
    char outputTopic[80];
    sprintf(outputTopic,"%stemperature",topic);
    client.publish(outputTopic, msg);
  }
  
}
