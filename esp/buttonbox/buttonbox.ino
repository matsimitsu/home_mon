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
bool leftButtonState = true;
bool leftButtonCurrent = true;

const int middleButton = 4;
bool middleButtonState = true;
bool middleButtonCurrent = true;

const int rightButton = 2;
bool rightButtonState = true;
bool rightButtonCurrent = true;

const bool pressed = false;

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
    if (client.connect("ESP8266Client")) {
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
      char msg[1];
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
      char msg[1];
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
      char msg[1];
      char outputTopic[80];
      sprintf(outputTopic,"%srightButton",topic);
      Serial.println(outputTopic);
      client.publish(outputTopic, msg);
    }
    rightButtonCurrent = rightButtonState;
  }
  
}
