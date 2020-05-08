
#include <Servo.h>
Servo servo1,servo2;
int LED = 13; // Use the onboard Uno LED
int isObstaclePin = 7;  // This is our input pin

int isObstacle = HIGH;  // HIGH MEANS NO OBSTACLE

int i = 1;
int j = 2;
int k = 3;
int l = 4;
char data=0;

void setup() {
   servo1.attach(5);
   servo2.attach(6);
  pinMode(LED, OUTPUT);
  pinMode(isObstaclePin, INPUT);
  Serial.begin(9600);
  
}

void loop() {
  if(Serial.available())
  {
    data=Serial.read();
  }
  isObstacle = digitalRead(isObstaclePin);
  if (isObstacle == LOW)
  {
    Serial.println(i);
    
    digitalWrite(LED, HIGH);
    delay(1000);
  }
  else
  {
    Serial.println(j);
    
    digitalWrite(LED, LOW);
  }
  if(data=='y')
  {
    servo1.write(25);
    delay(10000);
    servo1.write(125);
  }
  if(data=='l')
  {
    servo2.write(25);
    delay(5000);
    servo2.write(125);
  }
}
  

