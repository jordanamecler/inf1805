#include "Volume.h"
#include "mario.h"
#include "starwars.h"

Volume vol; // Plug your speaker into the default pin for your board type:
// https://github.com/connornishijima/arduino-volume#supported-pins 

// PINOS SENSORES DISTANCIA
#define echoPin_s1 7 // Echo Pin sensor 1
#define trigPin_s1 8 // Trigger Pin sensor 1
#define echoPin_s2 9 // Echo Pin sensor 2
#define trigPin_s2 10 // Trigger Pin sensor 2

// PINOS LED E BUZZER
#define LEDPin 13 // Onboard LED
#define buzzerPin 5

// VARIAVEIS DOS SENSORES DE DISTANCIA
unsigned long d1_time = 0;
unsigned long d2_time = 0;
bool d1_active = false;
bool d2_active = false;
unsigned long offset_time = 800;
int maximumRange = 200; // Maximum range needed
int minimumRange = 0; // Minimum range needed

// FAIXA DE FREQ AUDIVEL
#define maxfreq 20000
#define minfreq 20

// PLAYER SETTINGS
float masterVolume = 255;
int song_index = 0;


void setup() {
 Serial.begin (9600);
 pinMode(trigPin_s1, OUTPUT);
 pinMode(echoPin_s1, INPUT);
 pinMode(trigPin_s2, OUTPUT);
 pinMode(echoPin_s2, INPUT);
 pinMode(buzzerPin, OUTPUT);
 pinMode(LEDPin, OUTPUT); // Use LED indicator (if required)
 
 vol.begin(); // After calling this, millis(), delay() and delayMicroseconds will no longer work
               // correctly! Instead, use vol.millis(), vol.delay() and vol.delayMicroseconds() for
               // the correct timing

  vol.setMasterVolume(1.00); // Self-explanatory enough, right? Try lowering this value if the speaker is too loud! (0.00 - 1.00)
  vol.delay(500);
}

void setToneByDistance(int distance) {
  int hz = 100 * distance + 20;
  tone(buzzerPin, hz);
}

float setVolumeByDistance(int distance) {
  // 255 = 20a + b
  // 10 = 8a + b
  // x < 8 -> y = 0
  
   if (distance < 8) {
    Serial.println("Volume: 0");
    return 0;
   }
   float volumeValue = (245/12.0) * distance - 460.0/3;
   Serial.print("Volume: ");
   Serial.println(volumeValue);
   
   return volumeValue;
}

long getDistance(int sensor) {
  /* The following trigPin/echoPin cycle is used to determine the
 distance of the nearest object by bouncing soundwaves off of it. */ 
 int trig = 0, echo = 0;
 
 if (sensor == 1) {
  trig = trigPin_s1;
  echo = echoPin_s1;
 }
 else {
  trig = trigPin_s2;
  echo = echoPin_s2;
 }
 digitalWrite(trig, LOW); 
 delayMicroseconds(2); 

 digitalWrite(trig, HIGH);
 delayMicroseconds(10); 
 
 digitalWrite(trig, LOW);
 long duration = pulseIn(echo, HIGH);
 
 //Calculate the distance (in cm) based on the speed of sound.
 return duration/58.2;
 
}

int shouldChangeSong() {
  // -1: no / 0: next song / 1: previous song

  int d1 = getDistance(1);
  int d2 = getDistance(2);
   
   if (d1 > 2 && d1 < 5) {
     d1_time = vol.millis();
     d1_active = true;
     Serial.println("d1");
   }
   else if (vol.millis() - d1_time > offset_time) {
    d1_active = false;
   }
   if (d2 > 2 && d2 < 5) {
     d2_time = vol.millis();
     d2_active = true;
     Serial.println("d2");
   }
   else if (vol.millis() - d2_time > offset_time) {
    d2_active = false;
   }

   if (d1_active && d2_active) {
      Serial.print("d1_T: ");
      Serial.println(d1_time);
      Serial.print("d2_T: ");
      Serial.println(d2_time);
      d1_active = false;
      d2_active = false;
      if ((d1_time < d2_time) && ((d2_time - d1_time) < offset_time)) {
        Serial.println("esquerda pra direita");
        return 0;
       }     
      else if ((d2_time < d1_time) && ((d1_time - d2_time) < offset_time)) {
        Serial.println("direita pra esquerda");
        return 1;
      } 
   }
   return -1;
}



void loop() {

  int * songs_array[] = {sw_melody, mario_melody, underworld_melody};
  int * tempo_array[] = {sw_tempo, mario_tempo, underworld_tempo};
  int sizes_array[] = {sw_size, mario_size, underworld_size};
  
  int * melody = songs_array[song_index];
  int * tempo  = tempo_array[song_index];
  int melody_size = sizes_array[song_index];

  int song_size = sizeof(melody) / sizeof(int);
  for (int thisNote = 0; thisNote < melody_size; thisNote++) {

      long distance = getDistance(1);
      if (distance <= 20 && distance > 5){  
          masterVolume = setVolumeByDistance(distance);
       }
       else {
//         Serial.println("Fora de alcance");
       }

      int ret = shouldChangeSong();
      if (ret == 0) {
        song_index++;
        if (song_index > 2) song_index = 0;
        break;
      }
      else if (ret == 1) {
        song_index--;
        if (song_index < 0) song_index = 2;
        break;
      }
      
      int noteDuration = 0;
      if (song_index == 0) {
        noteDuration = tempo[thisNote];
      }
      else {
        noteDuration = 1000 * 1.3 / tempo[thisNote];
      }  
     
      vol.tone(melody[thisNote], masterVolume);
      vol.delay(noteDuration);
  }
}
