/*
 HC-SR04 Ping distance sensor:
 VCC to arduino 5v 
 GND to arduino GND
 Echo to Arduino pin 7 
 Trig to Arduino pin 8
 */
#include "Volume.h"
#include "mario.h"
#include "starwars.h"

Volume vol; // Plug your speaker into the default pin for your board type:
// https://github.com/connornishijima/arduino-volume#supported-pins 

#define echoPin 7 // Echo Pin
#define trigPin 8 // Trigger Pin
#define LEDPin 13 // Onboard LED
#define buzzerPin 5

#define maxfreq 20000
#define minfreq 20

int maximumRange = 200; // Maximum range needed
int minimumRange = 0; // Minimum range needed
float masterVolume = 255;


void setup() {
 Serial.begin (9600);
 pinMode(trigPin, OUTPUT);
 pinMode(echoPin, INPUT);
 pinMode(buzzerPin, OUTPUT);
 pinMode(LEDPin, OUTPUT); // Use LED indicator (if required)
 
 vol.begin(); // After calling this, delay() and delayMicroseconds will no longer work
               // correctly! Instead, use vol.delay() and vol.delayMicroseconds() for
               // the correct timing

  vol.setMasterVolume(1.00); // Self-explanatory enough, right? Try lowering this value if the speaker is too loud! (0.00 - 1.00)
  vol.delay(500);
}

void setToneByDistance(int distance) {
  int hz = 100 * distance + 20;
  tone(buzzerPin, hz);
  
  Serial.print("Distancia ");
  Serial.println(distance);
  Serial.print("hz ");
  Serial.println(hz);
}

float setVolumeByDistance(int distance) {
   if (distance < 3) return 0;
   float volumeValue = (255/10.0) * distance;
   Serial.println(distance);
   
   return volumeValue;
}

void loop() {
 
    Serial.println(" 'Mario Theme'");
    int size = sizeof(sw_melody) / sizeof(int);
    for (int thisNote = 0; thisNote < size; thisNote++) {
   
     
 
      long distance = getDistance();
       if (distance <= 20 && distance >= minimumRange){  
          masterVolume = setVolumeByDistance(distance);
       }
       else {
         Serial.println("Fora de alcance");
       }
      
//      int noteDuration = 1000 * / sw_tempo[thisNote];
      vol.tone(sw_melody[thisNote], masterVolume);
//      vol.delay(noteDuration);
        vol.delay(sw_tempo[thisNote]);
    }

 delay(50);
}

void buzz(int targetPin, long frequency, long length) {

  long delayValue = 1000000 / frequency / 2; // calculate the delay value between transitions
  //// 1 second's worth of microseconds, divided by the frequency, then split in half since
  //// there are two phases to each cycle
  long numCycles = frequency * length / 1000; // calculate the number of cycles for proper timing
  //// multiply frequency, which is really cycles per second, by the number of seconds to
  //// get the total number of cycles to produce
  for (long i = 0; i < numCycles; i++) { // for the calculated length of time...
    digitalWrite(targetPin, HIGH); // write the buzzer pin high to push out the diaphram
    delayMicroseconds(delayValue); // wait for the calculated delay value
    digitalWrite(targetPin, LOW); // write the buzzer pin low to pull back the diaphram
    delayMicroseconds(delayValue); // wait again or the calculated delay value
  }
 
}

long getDistance() {
  /* The following trigPin/echoPin cycle is used to determine the
 distance of the nearest object by bouncing soundwaves off of it. */ 
 digitalWrite(trigPin, LOW); 
 delayMicroseconds(2); 

 digitalWrite(trigPin, HIGH);
 delayMicroseconds(10); 
 
 digitalWrite(trigPin, LOW);
 long duration = pulseIn(echoPin, HIGH);
 
 //Calculate the distance (in cm) based on the speed of sound.
 return duration/58.2;
 
}


