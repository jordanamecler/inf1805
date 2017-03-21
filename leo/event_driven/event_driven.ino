#include "event_driven.h"
#include "main.h"

unsigned long timer = 0;
unsigned long lastTime = millis();

int lastState = 0;
int pinBitVector = -1;

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

  if (timer > -1 && millis() - lastTime > timer) {
     timer_expired(); 
     timer = -1;
  }
  
  if (pinBitVector) {
    int pin = A1;
    int auxPin = pinBitVector;
    
    while (auxPin) {
      if (auxPin & 1) {
         int state = digitalRead(pin);
    
         if (lastState != state) {
            lastState = state;
            button_changed(pin, state);   
         }   
      }
      pin++;
      auxPin >= 1;
    }   
  }
}
