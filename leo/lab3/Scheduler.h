#ifndef SCHEDULER_H
#define SCHEDULER_H

#include <avr/interrupt.h>
#include <avr/sleep.h>
#include <Arduino.h>

#define MAX_SLOTS 10  // Scheduler vector size

typedef void (*cbTask)(void);

class Scheduler {
  public:
  
    /*
 *      * Instantiate Scheduler
 *           */
    Scheduler();
    ~Scheduler();

    /*
 *      * Post a Task in a specific slot. Return false if the slot is not empty.
 *           * slot: Slot id
 *                * cb: Callback function
 *                     */
    boolean post(uint8_t slot, cbTask cb);

    /* 
 *      * Initialize internal slots and sleep mode - must be called from setup()
 *           */
    void init();
    
    /*
 *      * Main schedule loop. Must be called from loop().
 *           * Executes all pending tasks and goes to sleep mode.
 *                * The system awake on any interruption from Pins or Internal Timers.
 *                     */
    void loop();
};

#endif // SCHEDULER_H

