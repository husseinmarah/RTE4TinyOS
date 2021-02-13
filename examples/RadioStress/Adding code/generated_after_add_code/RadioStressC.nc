	#include "AM.h"
	
	module RadioStressC @safe() {
	uses interface Boot;
	uses interface BlockingStdControl as BlockingAMControl;
	uses interface Thread as RadioStressThread0;
	uses interface BlockingAMSend as BlockingAMSend0;
	uses interface BlockingReceive as BlockingReceive0;
	uses interface Thread as RadioStressThread1;
	uses interface BlockingAMSend as BlockingAMSend1;
	uses interface BlockingReceive as BlockingReceive1;
	uses interface Thread as RadioStressThread2;
	uses interface BlockingAMSend as BlockingAMSend2;
	uses interface BlockingReceive as BlockingReceive2;
	uses interface Leds;
	uses interface Timer<TMilli> as TestTimer;
	uses interface SplitControl as TestRadioControl;
	
	}
	implementation {
	   /* nesc code */
		message_t m0;
		message_t m1;
		message_t m2;
	
	
		 task void incrementCounter() {
	  /* task content */
	   sharedCounter++;
		if (call TestTimer.isRunning() != TRUE)
		{
			post incrementCounter();
			dbg("RadioStressC", "TestTimer still running @ %s.\n", sim_time_string());
			}
		else
		{
			dbg("RadioStressC", "TestTimer stop running @ %s.\n", sim_time_string());
			}
	 }
	
	    event void Boot.booted() {
	   /* event content */
	   
	    call RadioStressThread0.start(NULL);
	    call RadioStressThread1.start(NULL);
	    call RadioStressThread2.start(NULL);
	  
	 }
	    event void RadioStressThread0.run(void* arg) {
	   /* event content */
	   
	    call BlockingAMControl.start();
	    for(;;) {
	      if(TOS_NODE_ID == 0) {
	        call BlockingReceive0.receive(&m0, 5000);
	        call Leds.led0Toggle();
	      }
	      else {
	        call BlockingAMSend0.send(!TOS_NODE_ID, &m0, 0);
	        call Leds.led0Toggle();
	        //call RadioStressThread0.sleep(500);
	      }
	    }
	  
	 }
	    event void RadioStressThread1.run(void* arg) {
	   /* event content */
	   
	    call BlockingAMControl.start();
	    for(;;) {
	      if(TOS_NODE_ID == 0) {
	        call BlockingReceive1.receive(&m1, 5000);
	        call Leds.led1Toggle();
	      }
	      else {
	        call BlockingAMSend1.send(!TOS_NODE_ID, &m1, 0);
	        call Leds.led1Toggle();
	        //call RadioStressThread1.sleep(500);
	      }
	    }
	  
	 }
	    event void RadioStressThread2.run(void* arg) {
	   /* event content */
	   
	    call BlockingAMControl.start();
	    for(;;) {
	      if(TOS_NODE_ID == 0) {
	        call BlockingReceive2.receive(&m2, 5000);
	        call Leds.led2Toggle();
	      }
	      else {
	        call BlockingAMSend2.send(!TOS_NODE_ID, &m2, 0);
	        call Leds.led2Toggle();
	        //call RadioStressThread2.sleep(500);
	      }
	    }
	  
	 }
	    event void TestTimer.fired() {
	   /* event content */
	   sharedCounter++;
		dbg("RadioStressC", "TestTimer was run successfully @ %s.\n", sim_time_string());
	 }
	    event void EditedRadioControl.startDone(error_t err) {
	   /* event content */
	   if (err == SUCCESS) {
	     dbg("RadioStressC", "RadioControl was run successfully @ %s.\n", sim_time_string());
	    }
		call RadioControl.stop();
	 }
	    event void EditedRadioControl.stopDone(error_t err) {
	   /* event content */
	   if (err == SUCCESS) {
	  dbg("RadioStressC", "RadioControl was stop successfully @ %s.\n", sim_time_string());
	  }  
	 }
	
	}
	
	
	
