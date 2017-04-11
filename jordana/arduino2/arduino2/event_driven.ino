#include "event_driven.h"
#include "arduino2.h"

unsigned long old = millis();
unsigned long timer = 0;
int lastStates[] = {0, 0, 0};
bool usedButtons[] = {false, false, false};

void setup() {
  inicia();
}

void pciSetup(byte pin)
{
  // enable pin
  *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));
  // clear any outstanding interrupt (Interrupt Flag) 
  PCIFR  |= bit (digitalPinToPCICRbit(pin)); 
  // enable interrupt for the group (Interrupt Control)
  PCICR  |= bit (digitalPinToPCICRbit(pin)); 
}

void button_listen(byte pin) {
  pciSetup(pin);
  usedButtons[pin - KEY1] = true;
}

ISR(PCINT1_vect) {
  int i;
  for(i = 0; i < 3; i++) {
    if(usedButtons[i]) {
    int val = digitalRead(i + KEY1);
      if(val != lastStates[i]) {
        lastStates[i] = val;
        button_changed(i + KEY1, val);
      }
    }
  }
}

void timer_set(int ms) {
  timer = ms;
}

void loop() {
  
  if(millis() - old >= timer) {
    timer_expired();  
    old = millis();
  }
}
