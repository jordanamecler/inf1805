#include "event_driven.h"
#include "main.h"

unsigned long timer = 0;
unsigned long lastTime = millis();

unsigned lastStateVector = 0;
unsigned pinBitVector = 0;

void button_listen(int pins) {
  pinBitVector = pins;
}

void timer_set(int ms) {
  if (ms > 0)
    timer = ms;
}

void setup() {
  inic();
}

void loop() {

  if (timer > 0 && millis() - lastTime > timer) {
     timer_expired(); 
     lastTime = millis();
  }
  
  if (pinBitVector) {
    int pin = A1;
    int auxPin = pinBitVector;
    int i = 0;
    
    while (auxPin) {
      if (auxPin & 1) {
         int state = digitalRead(pin);
         if (((lastStateVector >> i) & 1) != state) {
            lastStateVector = lastStateVector ^ (1 << i);
            button_changed(pin, state); 
         }   
      }
      pin++;
      auxPin >>= 1;
      i++;
    }   
  }
}
