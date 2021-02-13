	#include "<Timer.h>"
	
	module TestDisseminationC @safe() {
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as DisseminationControl;
	uses interface DisseminationValue<uint32_t> as Value32;
	uses interface DisseminationUpdate<uint32_t> as Update32;
	uses interface DisseminationValue<uint16_t> as Value16;
	uses interface DisseminationUpdate<uint16_t> as Update16;
	uses interface Leds;
	uses interface Timer<TMilli>;
	uses interface Timer<TMilli> as TestTimer;
	uses interface SplitControl as TestRadioControl;
	
	}
	implementation {
	   /* nesc code */
	
	
		 task void incrementCounter() {
	  /* task content */
	   sharedCounter++;
		if (call TestTimer.isRunning() != TRUE)
		{
			post incrementCounter();
			dbg("TestDisseminationC", "TestTimer still running @ %s.\n", sim_time_string());
			}
		else
		{
			dbg("TestDisseminationC", "TestTimer stop running @ %s.\n", sim_time_string());
			}
	 }
	
	    event void Boot.booted() {
	   /* event content */
	   
	    uint32_t initialVal32 = 123456;
	    uint16_t initialVal16 = 1234;
	
	    call Value32.set( &initialVal32 ); 
	    call Value16.set( &initialVal16 ); 
	
	    call RadioControl.start();
	  
	 }
	    event void RadioControl.startDone( error_t result ) {
	   /* event content */
	   
	    
	    if ( result != SUCCESS ) {
	
	      call RadioControl.start();
	
	    } else {
	
	      call DisseminationControl.start();
	      
	      if ( TOS_NODE_ID % 4 == 1 ) {
		call Timer.startPeriodic( 1024 * 20 );
	      } else {
		call Timer.startPeriodic( 1024 );
	      }
	    }
	  
	 }
	    event void RadioControl.stopDone( error_t result ) {
	   /* event content */
	    
	 }
	    event void Timer.fired() {
	   /* event content */
	   
	    uint32_t newVal32 = 0xDEADBEEF;
	    uint16_t newVal16 = 0xABCD;
	
	    if ( TOS_NODE_ID % 4 == 1 ) {
	      call Leds.led0Toggle();
	      call Leds.led1Toggle();
	      call Update32.change( &newVal32 );
	      call Update16.change( &newVal16 );
	      dbg("TestDisseminationC", "TestDisseminationC: Timer fired.\n");
	    } else {
	      const uint32_t* newVal = call Value32.get();
	      if ( *newVal == 123456 ) {
		call Leds.led2Toggle();
	      }
	    }
	  
	 }
	    event void Value32.changed() {
	   /* event content */
	   
	    const uint32_t* newVal = call Value32.get();
	    if ( *newVal == 0xDEADBEEF ) {
	      call Leds.led0Toggle();
	      dbg("TestDisseminationC", "Received new correct 32-bit value @ %s.\n", sim_time_string());
	    }
	    else {
	      dbg("TestDisseminationC", "Received new incorrect 32-bit value.\n");
	    }
	  
	 }
	    event void Value16.changed() {
	   /* event content */
	   
	    const uint16_t* newVal = call Value16.get();
	    if ( *newVal == 0xABCD ) {
	      call Leds.led1Toggle();
	      dbg("TestDisseminationC", "Received new correct 16-bit value @ %s.\n", sim_time_string());
	    }
	    else {
	      dbg("TestDisseminationC", "Received new incorrect 16-bit value: 0x%hx\n", *newVal);
	    }
	  
	 }
	    event void TestTimer.fired() {
	   /* event content */
	   sharedCounter++;
		dbg("TestDisseminationC", "TestTimer was run successfully @ %s.\n", sim_time_string());
	 }
	    event void RadioControl.startDone(error_t err) {
	   /* event content */
	   f (err == SUCCESS) {
	     dbg("TestDisseminationC", "TestRadioControl was run successfully @ %s.\n", sim_time_string());
	    }
		call TestRadioControl.stop();
	 }
	    event void RadioControl.stopDone(error_t err) {
	   /* event content */
	   if (err == SUCCESS) {
	  dbg("TestDisseminationC", "TestRadioControl was stop successfully @ %s.\n", sim_time_string());
	  }  
	 }
	
	}
	
	
	
