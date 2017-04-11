#include "event_driven.h"
#include "arduino2.h"

TimerService myTimer;
Scheduler taskCtl;
int lastStates[] = {0, 0, 0};
bool usedButtons[] = {false, false, false};

void setup() {
  myTimer.init();
  taskCtl.init();
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
//        taskCtl.post(0, button_changed(i + KEY1, val);
        button_changed(i + KEY1, val);
      }
    }
  }
}

void timer_set(int ms) {  
  myTimer.set(0, ms/1000.0, timer_expired);
}

void loop() {
  taskCtl.loop();
}
