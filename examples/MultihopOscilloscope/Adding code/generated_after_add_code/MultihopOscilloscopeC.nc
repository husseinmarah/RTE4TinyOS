	#include "Timer.h"
	
	#include "MultihopOscilloscope.h"
	
	module MultihopOscilloscopeC @safe() {
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface SplitControl as SerialControl;
	uses interface StdControl as RoutingControl;
	uses interface Send;
	uses interface Receive as Snoop;
	uses interface Receive;
	uses interface AMSend as SerialSend;
	uses interface CollectionPacket;
	uses interface RootControl;
	uses interface Queue<message_t *> as UARTQueue;
	uses interface Pool<message_t> as UARTMessagePool;
	uses interface Timer<TMilli>;
	uses interface Read<uint16_t>;
	uses interface Leds;
	uses interface Timer<TMilli> as TestTimer;
	uses interface SplitControl as RadioControl;
	
	}
	implementation {
	   /* nesc code */
		uint8_t testCounter;
		uint8_t uartlen;
		message_t sendbuf;
		message_t uartbuf;
		bool sendbusy=FALSE, uartbusy=FALSE;
		oscilloscope_t local;
		uint8_t reading;
		bool suppress_count_change;
	
	
		 task void testTask(); {
	  /* task content */
	   
	 }
		 task void uartSendTask(); {
	  /* task content */
	   
	 }
		 task void uartSendTask() {
	  /* task content */
	   
	    if (call SerialSend.send(0xffff, &uartbuf, uartlen) != SUCCESS) {
	      report_problem();
	    } else {
	      uartbusy = TRUE;
	    }
	  
	 }
		 task void testTask() {
	  /* task content */
	   
			testCounter++;
		if (call TestTimer.isRunning() != TRUE)
		{
			
			dbg("MultihopOscilloscopeC", "TestTimer still running @ %s.\n", sim_time_string());
			}
		else
		{
		    post testTask();
			dbg("MultihopOscilloscopeC", "TestTimer stop running @ %s.\n", sim_time_string());
			}
			
		
	 }
	
	    event void Boot.booted() {
	   /* event content */
	   
	    local.interval = DEFAULT_INTERVAL;
	    local.id = TOS_NODE_ID;
	    local.version = 0;
	
	    // Beginning our initialization phases:
	    if (call RadioControl.start() != SUCCESS)
	      fatal_problem();
	
	    if (call RoutingControl.start() != SUCCESS)
	      fatal_problem();
	  
	 }
	    event void RadioControl.startDone(error_t error) {
	   /* event content */
	   
	    if (error != SUCCESS)
	      fatal_problem();
	
	    if (sizeof(local) > call Send.maxPayloadLength())
	      fatal_problem();
	
	    if (call SerialControl.start() != SUCCESS)
	      fatal_problem();
	  
	 }
	    event void SerialControl.startDone(error_t error) {
	   /* event content */
	   
	    if (error != SUCCESS)
	      fatal_problem();
	
	    // This is how to set yourself as a root to the collection layer:
	    if (local.id % 500 == 0)
	      call RootControl.setRoot();
	
	    startTimer();
	  
	 }
	    event void RadioControl.stopDone(error_t error) {
	   /* event content */
	    
	 }
	    event void SerialControl.stopDone(error_t error) {
	   /* event content */
	    
	 }
	    event void message_t* Receive.receive(message_t* msg, void *payload, uint8_t len) {
	   /* event content */
	   
	    oscilloscope_t* in = (oscilloscope_t*)payload;
	    oscilloscope_t* out;
		//call Leds.led0Toggle(); //this for debugging purpose, it will show the red led0On
	    if (uartbusy == FALSE) {
	      out = (oscilloscope_t*)call SerialSend.getPayload(&uartbuf, sizeof(oscilloscope_t));
	      if (len != sizeof(oscilloscope_t) || out == NULL) {
			return msg;
	      }
	      else {
			memcpy(out, in, sizeof(oscilloscope_t));
	      }
	      uartlen = sizeof(oscilloscope_t);
	      post uartSendTask();
	    } else {
	      // The UART is busy; queue up messages and service them when the
	      // UART becomes free.
	      message_t *newmsg = call UARTMessagePool.get();
	      if (newmsg == NULL) {
	        // drop the message if we run out of queue space.
	        report_problem();
	        return msg;
	      }
	
	      //Serial port busy, so enqueue.
	      out = (oscilloscope_t*)call SerialSend.getPayload(newmsg, sizeof(oscilloscope_t));
	      if (out == NULL) {
			return msg;
	      }
	      memcpy(out, in, sizeof(oscilloscope_t));
	
	      if (call UARTQueue.enqueue(newmsg) != SUCCESS) {
	        // drop the message and hang if we run out of
	        // queue space without running out of queue space first (this
	        // should not occur).
	        call UARTMessagePool.put(newmsg);
	        fatal_problem();
	        return msg;
	      }
	    }
	    return msg;
	  
	 }
	    event void SerialSend.sendDone(message_t *msg, error_t error) {
	   /* event content */
	   
	    uartbusy = FALSE;
	    if (call UARTQueue.empty() == FALSE) {
	      // We just finished a UART send, and the uart queue is
	      // non-empty.  Let's start a new one.
	      message_t *queuemsg = call UARTQueue.dequeue();
	      if (queuemsg == NULL) {
	        fatal_problem();
	        return;
	      }
	      memcpy(&uartbuf, queuemsg, sizeof(message_t));
	      if (call UARTMessagePool.put(queuemsg) != SUCCESS) {
	        fatal_problem();
	        return;
	      }
	      post uartSendTask();
	    }
	  
	 }
	    event void message_t* Snoop.receive(message_t* msg, void* payload, uint8_t len) {
	   /* event content */
	   
	    oscilloscope_t *omsg = payload;
	
	    report_received();
	
	    // If it receive a newer version, update the interval. 
	    if (omsg->version > local.version) {
	      local.version = omsg->version;
	      local.interval = omsg->interval;
	      startTimer();
	    }
	
	    // If it hear from a future count, jump ahead but suppress the change.
	    if (omsg->count > local.count) {
	      local.count = omsg->count;
	      suppress_count_change = TRUE;
	    }
	
	    return msg;
	  
	 }
	    event void Timer.fired() {
	   /* event content */
	   
	    if (reading == NREADINGS) {
	      if (!sendbusy) {
		oscilloscope_t *o = (oscilloscope_t *)call Send.getPayload(&sendbuf, sizeof(oscilloscope_t));
		if (o == NULL) {
		  fatal_problem();
		  return;
		}
		memcpy(o, &local, sizeof(local));
		if (call Send.send(&sendbuf, sizeof(local)) == SUCCESS)
		  sendbusy = TRUE;
	        else
	          report_problem();
	      }
	      
	      reading = 0;
	      /* Part 2 of cheap "time sync": increment our count if we didn't
	         jump ahead. */
	      if (!suppress_count_change)
	        local.count++;
	      suppress_count_change = FALSE;
	    }
	
	    if (call Read.read() != SUCCESS)
	      fatal_problem();
	  
	 }
	    event void Send.sendDone(message_t* msg, error_t error) {
	   /* event content */
	   
	    if (error == SUCCESS)
	      report_sent();
	    else
	      report_problem();
	
	    sendbusy = FALSE;
	  
	 }
	    event void Read.readDone(error_t result, uint16_t data) {
	   /* event content */
	   
	    if (result != SUCCESS) {
	      data = 0xffff;
	      report_problem();
	    }
	    if (reading < NREADINGS)
	      local.readings[reading++] = data;
	  
	 }
	    event void TestTimer.fired() {
	   /* event content */
	   
	    testCounter++;
		dbg("MultihopOscilloscopeC", "TestTimer was run successfully @ %s.\n", sim_time_string());
	  
	 }
	    event void RadioControl.startDone(error_t err) {
	   /* event content */
	   
	    if (err != SUCCESS) {
	     call RadioControl.stop();
	    }
		dbg("MultihopOscilloscopeC", "RadioControl was run successfully @ %s.\n", sim_time_string());
	  
	 }
	    event void RadioControl.stopDone(error_t err) {
	   /* event content */
	   
	  if (err == SUCCESS) {
	  dbg("MultihopOscilloscopeC", "RadioControl was stop successfully @ %s.\n", sim_time_string());
	  }  
	  
	 }
	
	}
	
	
	
