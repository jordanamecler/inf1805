#include "main.h"

void button_changed(int pin, int v) {
    Serial.print("Botao ");
    Serial.print(pin);
    Serial.print(" mudou para ");
    Serial.println(v); 
}

void timer_expired() {
    Serial.println("Tempo expirou...");
}

void inic() {
  Serial.begin(9600);
  
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);

  timer_set(1000);
  button_listen(KEY1 | KEY3);
}
