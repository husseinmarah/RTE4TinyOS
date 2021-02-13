	#include "MViz.h"
	
	module MVizC @safe() {
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
	uses interface Timer<TMilli>;
	uses interface Read<uint16_t>;
	uses interface Leds;
	uses interface CtpInfo;
	uses interface LinkEstimator;
	uses interface Random;
	
	}
	implementation {
	   /* nesc code */
		uint8_t uartlen;
		message_t sendbuf;
		message_t uartbuf;
		bool sendbusy=FALSE, uartbusy=FALSE;
		mviz_msg_t local;
		uint8_t reading;
		bool suppress_count_change;
	
	
	  task void uartSendTask();
		 task void uartSendTask() {
	  /* task content */
	   
		  /* task content */
		   
		    if (call SerialSend.send(0xffff, &uartbuf, uartlen) != SUCCESS) {
		      uartbusy = FALSE;
		    }
		  
		 
	 }
	
	    event void Boot.booted() {
	   /* event content */
	   
		   /* event content */
		   
		    local.interval = DEFAULT_INTERVAL;
		    local.origin = TOS_NODE_ID;
		
		    // Beginning our initialization phases:
		    if (call RadioControl.start() != SUCCESS)
		      fatal_problem();
		
		    if (call RoutingControl.start() != SUCCESS)
		      fatal_problem();
		  
		 
	 }
	    event void RadioControl.startDone(error_t error) {
	   /* event content */
	   
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
	   
		   /* event content */
		   
		    if (error != SUCCESS)
		      fatal_problem();
		
		    // This is how to set yourself as a root to the collection layer:
		    if (local.origin % 500 == 0)
		      call RootControl.setRoot();
		
		    startTimer();
		  
		 
	 }
	    event void RadioControl.stopDone(error_t error) {
	   /* event content */
	   
		   /* event content */
		    
		 
	 }
	    event void SerialControl.stopDone(error_t error) {
	   /* event content */
	   
		   /* event content */
		    
		 
	 }
	    event void message_t*
		  Receive.receive(message_t* msg, void *payload, uint8_t len) {
	   /* event content */
	   
		   /* event content */
		   
		    if (uartbusy == FALSE) {
		      mviz_msg_t* in = (mviz_msg_t*)payload;
		      mviz_msg_t* out = (mviz_msg_t*)call SerialSend.getPayload(&uartbuf, sizeof(mviz_msg_t));
		      if (out == NULL) {
			return msg;
		      }
		      else {
			memcpy(out, in, sizeof(mviz_msg_t));
		      }
		      uartbusy = TRUE;
		      uartlen = sizeof(mviz_msg_t);
		      post uartSendTask();
		    }
		
		    return msg;
		  
		 
	 }
	    event void message_t* Snoop.receive(message_t* msg, void* payload, uint8_t len) {
	   /* event content */
	   
		   /* event content */
		   
		    mviz_msg_t *omsg = payload;
		
		    report_received();
		
		    // If we receive a newer version, update our interval. 
		    if (omsg->version > local.version) {
		      local.version = omsg->version;
		      local.interval = omsg->interval;
		      startTimer();
		    }
		
		    // If we hear from a future count, jump ahead but suppress our own
		    // change.
		    if (omsg->count > local.count) {
		      local.count = omsg->count;
		      suppress_count_change = TRUE;
		    }
		
		    return msg;
		  
		 
	 }
	    event void Send.sendDone(message_t* msg, error_t error) {
	   /* event content */
	   
		   /* event content */
		   
		    if (error == SUCCESS)
		      report_sent();
		    else
		      report_problem();
		
		    sendbusy = FALSE;
		  
		 
	 }
	    event void Read.readDone(error_t result, uint16_t data) {
	   /* event content */
	   
		   /* event content */
		   
		    uint16_t val;
		    if (result != SUCCESS) {
		      data = 0xffff;
		      report_problem();
		    }
		    local.reading = data;
		    call CtpInfo.getEtx(&val);
		    local.etx = val;
		    call CtpInfo.getParent(&val);
		    local.link_route_addr = val;
		    local.link_route_value = call LinkEstimator.getLinkQuality(local.link_route_addr);
		  
		 
	 }
	    event void LinkEstimator.evicted(am_addr_t addr) {
	   /* event content */
	   
		   /* event content */
		   
		 
	 }
	    event void SerialSend.sendDone(message_t *msg, error_t error) {
	   /* event content */
	   
		   /* event content */
		   
		    uartbusy = FALSE;
		  
		 
	 }
	
	}
	
	
	
