#include "Scheduler.h"

cbTask tasks[MAX_SLOTS];
boolean pendTasks=false;

    Scheduler::Scheduler(){
      
    }
    
    Scheduler::~Scheduler(){
      
    }

    boolean Scheduler::post(uint8_t slot, cbTask cb){
      if (slot >= MAX_SLOTS){
        return false;
      } else {
        if (tasks[slot]==0){
          cli();
          tasks[slot]=cb;
          pendTasks=true;
          sei();
          return true;
        } else {
          return false;
        }
      }
    }
    
    void Scheduler::init(){
      set_sleep_mode(SLEEP_MODE_IDLE);
      for (int i=0; i<MAX_SLOTS; i++) tasks[i]=0;
      pendTasks=false;
    }
    
    void execTasks(){
      if (pendTasks==true){
        for (int i=0; i<MAX_SLOTS; i++){
          if (tasks[i]!=0) {
            cbTask currentTask = tasks[i];
            tasks[i]=0;
            currentTask(); // Call back a task
          }
        }
        // Re-check pendTask
        cli();
        pendTasks=false;
        for (int i=0; i<MAX_SLOTS; i++){
          if (tasks[i]!=0) {
            pendTasks=true; 
            sei(); 
            return;
          }
        }
        sei();
      }
    }
    
    
    void Scheduler::loop(){
      cli();
      if (pendTasks==false)
      {
        sleep_enable();
        sei();
        sleep_cpu();
        sleep_disable();
      }
      sei(); // reativo todas as interrupÃ§Ãµes se eu precisar delas.
      execTasks();
    }

