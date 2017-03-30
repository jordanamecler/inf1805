#include "arduino1.h"

bool ledOn = false;
int maxSeg = 1000;

unsigned long time_but1 = 0;
unsigned long time_but2 = 0;

int lastBut1 = 1;
int lastBut2 = 1;

void inicia(void) {
  Serial.begin(9600);
  pinMode(LED1, OUTPUT);
  button_listen(KEY1);
  button_listen(KEY2);
  timer_set(maxSeg);
}

void button_changed(int pin, int v) {
  Serial.print(maxSeg);
  if(pin == KEY1 && !v) {
    time_but1 = millis();
  }
  if(pin == KEY2 && !v) {
    time_but2 = millis();
  } 
  
  if((time_but1 || time_but2) && abs(time_but1 - time_but2) < 500) {
    Serial.print("entro aki");
    digitalWrite(LED1, LOW);
    while(1);
  }
  
  if(pin == KEY1 && v && !lastBut1) {
    maxSeg /= 1.1;
    timer_set(maxSeg);
  }
  
  if(pin == KEY2 && v && !lastBut2) {
    maxSeg *= 1.1;
    timer_set(maxSeg);
  }
  
  lastBut1 = v;
  lastBut2 = v;

  Serial.print(pin);
  Serial.print(" mudou para ");
  Serial.println(v);
}

void timer_expired() {
  if(ledOn)
    digitalWrite(LED1, HIGH);
  else
    digitalWrite(LED1, LOW);
  ledOn = !ledOn;
  Serial.println(maxSeg);
  timer_set(maxSeg);
  Serial.println("Timer expirou");
}
