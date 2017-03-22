#define LED_PIN 13
#define BUT_PIN1 A1
#define BUT_PIN2 A2

unsigned long time = millis();
unsigned long time_but1 = 0;
unsigned long time_but2 = 0;
int lastBut1 = 1;
int lastBut2 = 1;
int maxSeg = 1000;
bool ledOn = false;

// the setup function runs once when you press reset or power the brd
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUT_PIN1, INPUT);
  pinMode(BUT_PIN2, INPUT);
}

// the loop function runs over and over again forever
void loop() {
  
  if((millis() - time) > maxSeg) {
    if(ledOn)
      digitalWrite(LED_PIN, LOW);
    else
      digitalWrite(LED_PIN, HIGH);
    ledOn = !ledOn;
    time = millis();
  }
  
  int but1 = digitalRead(BUT_PIN1);
  int but2 = digitalRead(BUT_PIN2);
  
  if(!but1)
    time_but1 = millis();
  if(!but2)
    time_but2 = millis();
  
  if((time_but1 || time_but2) && abs(time_but1 - time_but2) < 500) {
    digitalWrite(LED_PIN, LOW);
    while(1);
  }
  
  if(but1 && !lastBut1)
    maxSeg /= 1.1;
    
  if(but2 && !lastBut2)
    maxSeg *= 1.1;
    
  lastBut1 = but1;
  lastBut2 = but2;
}

