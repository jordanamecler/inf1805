#include "event_driven.h"
#include "arduino1.h"

unsigned long old = millis();
unsigned long timer = 0;
int valorAntigo[3];
int observaBotao[3];

void setup() {
  int i;
  for(i = 0; i < 3; i++) {
    observaBotao[i] = 0;
    valorAntigo[i] = 0;
   }
  inicia();
}

void button_listen(int pin) {
  pinMode(pin, INPUT);
  observaBotao[pin - KEY1] = 1;
}

void timer_set(int ms) {
  timer = ms;
}

void loop() {
  
  if(millis() - old >= timer) {
    timer_expired();  
    old = millis();
  }
  
  int i;
  for(i = 0; i < 3; i++) {
    if(observaBotao[i]) {
      int valor = digitalRead(i + KEY1);
      if(valor != valorAntigo[i]) {
        button_changed(i + KEY1, valor);
        valorAntigo[i] = valor;
      }
    }
  }
}
