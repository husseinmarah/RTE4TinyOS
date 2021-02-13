	module BarrierBounceC @safe() {
	uses interface Boot;
	uses interface BlockingStdControl as BlockingAMControl;
	uses interface Barrier;
	uses interface Thread as BounceThread0;
	uses interface BlockingAMSend as BlockingAMSend0;
	uses interface BlockingReceive as BlockingReceive0;
	uses interface Thread as BounceThread1;
	uses interface BlockingAMSend as BlockingAMSend1;
	uses interface BlockingReceive as BlockingReceive1;
	uses interface Thread as BounceThread2;
	uses interface BlockingAMSend as BlockingAMSend2;
	uses interface BlockingReceive as BlockingReceive2;
	uses interface Thread as SyncThread;
	uses interface Leds;
	uses interface Timer<TMilli> as TestTimer;
	uses interface SplitControl as RadioControl;
	
	}
	implementation {
	   /* nesc code */
		uint8_t sharedCounter;
		message_t m0,m1,m2;
		barrier_t b0;
	
	
	
	    event void Boot.booted() {
	   /* event content */
	   
	    //Reset all barriers used in this program at initialization
	    call Barrier.reset(&b0, 4);
	
	    //Start the sync thread to power up the AM layer
	    call SyncThread.start(NULL);
		
		
		call TestTimer.startPeriodic( 600 );
			call RadioControl.start();
	  
	 }
	    event void BounceThread0.run(void* arg) {
	   /* event content */
	   
	    for(;;) {
	      call Leds.led0Off();
	      call BlockingAMSend0.send(!TOS_NODE_ID, &m0, 0);
	      if(call BlockingReceive0.receive(&m0, 5000) == SUCCESS) {
	        call Barrier.block(&b0);
	        call Leds.led0On();
	      	call BounceThread0.sleep(500);
	      }
	    }
	  
	 }
	    event void BounceThread1.run(void* arg) {
	   /* event content */
	   
	    for(;;) {
	      call Leds.led1Off();
	      call BlockingAMSend1.send(!TOS_NODE_ID, &m1, 0);
	      if(call BlockingReceive1.receive(&m1, 5000) == SUCCESS) {
	        call Barrier.block(&b0);
	        call Leds.led1On();
	      	call BounceThread1.sleep(500);
	      }
	    }
	  
	 }
	    event void BounceThread2.run(void* arg) {
	   /* event content */
	    
	    for(;;) {
	      call Leds.led2Off();
	      call BlockingAMSend2.send(!TOS_NODE_ID, &m2, 0);
	      if(call BlockingReceive2.receive(&m2, 5000) == SUCCESS) {
	        call Barrier.block(&b0);
	        call Leds.led2On();
	      	call BounceThread2.sleep(500);
	      }
	    }
	  
	 }
	    event void SyncThread.run(void* arg) {
	   /* event content */
	   
	    //Once the am layer is powered on, start the rest of
	    //  the threads
	    call BlockingAMControl.start();
	    call BounceThread0.start(NULL);
	    call BounceThread1.start(NULL);
	    call BounceThread2.start(NULL);
	    
	    for(;;) {
	      call Barrier.block(&b0);
	      call Barrier.reset(&b0, 4);
	    }
	  
	 }
	    event void TestTimer.fired() {
	   /* event content */
	   
	    sharedCounter++;
		dbg("BounceC", "TestTimer was run successfully @ %s.\n", sim_time_string());
	  
	 }
	    event void RadioControl.startDone(error_t err) {
	   /* event content */
	   
	    if (err == SUCCESS) {
	     dbg("BounceC", "RadioControl was run successfully @ %s.\n", sim_time_string());
	    }
		call RadioControl.stop();
	  
	 }
	
	}
	
	
	
