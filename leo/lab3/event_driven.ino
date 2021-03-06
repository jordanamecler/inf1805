#include "event_driven.h"
#include "lab3.h"

TimerService myTimer;  

unsigned long timer = 0;
unsigned long lastTime = millis();

int lastStates[] = {1, 1, 1};
int activePins[] = {0, 0, 0};

void pciSetup(byte pin)  {
  *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));
  PCIFR  |= bit (digitalPinToPCICRbit(pin)); 
  PCICR  |= bit (digitalPinToPCICRbit(pin)); 
}

void button_listen(byte pin) {
  pciSetup(pin);
  activePins[pin - KEY1] = 1;
}

void timer_set(float ms) {
   myTimer.stop();
   myTimer.set(0, ms/1000, timer_expired);
}

// Use one Routine to handle each group
 
ISR (PCINT1_vect) // handle pin change interrupt for A0 to A5 here
 {
     int states[] = {digitalRead(A1), digitalRead(A2), digitalRead(A3)};
     
     for (int i = 0; i < 3; i++) {
        if (activePins[i]) {
          if (states[i] != lastStates[i]) {
             lastStates[i] =  states[i];
             button_changed(KEY1 + i, states[i]);          
          }
        }
     }

 }   

void setup() {
  myTimer.init();

  inic();
}

void loop() {

 
}
