#include "arduino1.h"

void inicia (void) {
  button_listen (KEY1);
  button_listen (KEY2);
  button_listen (KEY3);
  timer_set (2000);
}

void button_changed (int pin, int v) {
  Serial.print (pin + KEY1);
  Serial.print (" mudou para ");
  Serial.println (v);
}

void timer_expired () {
  timer_set(2000);
  Serial.println ("Timer expirou");
}
