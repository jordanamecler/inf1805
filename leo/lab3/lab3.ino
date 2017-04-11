#define LED_PIN 13
#define BUT_PIN1 A1
#define BUT_PIN2 A2

#include "lab3.h"

typedef struct button {
  int lastInput;
  unsigned long lastTime;
} Button;

bool ledOn = false;
Button b1;
Button b2;
int maxSeg = 1000;

void button_changed(int pin, int v) {
    
    
    if (pin == BUT_PIN1) {
      if(v && !b1.lastInput) maxSeg /= 1.1;
      b1.lastTime = millis();
      b1.lastInput = v;
    }
    else if (pin == BUT_PIN2 ) {
      if(v && !b2.lastInput) maxSeg *= 1.1;
      b2.lastTime = millis(); 
      b2.lastInput = v; 
    }
  
  if ((b1.lastTime || b2.lastTime) && abs(b1.lastTime - b2.lastTime) < 500) {
    digitalWrite(LED_PIN, LOW);
    while(1);
  }
  timer_set(maxSeg);
}

void timer_expired() {
    if(ledOn)
      digitalWrite(LED_PIN, LOW);
    else
      digitalWrite(LED_PIN, HIGH);
    ledOn = !ledOn;      
}

void inic() {
  b1.lastInput = 1;
  b1.lastTime = 0;
  
  b2.lastInput = 1;
  b2.lastTime = 0;
  
  Serial.begin(9600);
  
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(LED_PIN, OUTPUT);

  timer_set(maxSeg);
  button_listen(KEY1 | KEY2);  
}
