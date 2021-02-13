	module PacketParrotP @safe() {
	uses interface Boot;
	uses interface Leds;
	uses interface Packet;
	uses interface Send;
	uses interface Receive;
	uses interface SplitControl as AMControl;
	uses interface LogRead;
	uses interface LogWrite;
	uses interface Timer<TMilli> as Timer0;
	
	}
	implementation {
	   /* nesc code */
		enum { INTER_PACKET_INTERVAL = 25
		};
		bool m_busy = TRUE;
		logentry_t m_entry;
	
	
	
	    event void Boot.booted() {
	   /* event content */
	   
		   /* event content */
		   
		    call AMControl.start();
		  
		 
	 }
	    event void AMControl.startDone(error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		    if (err == SUCCESS) {
		      if (call LogRead.read(&m_entry, sizeof(logentry_t)) != SUCCESS) {
			// Handle error.
		      }
		    }
		    else {
		      call AMControl.start();
		    }
		  
		 
	 }
	    event void AMControl.stopDone(error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		  
		 
	 }
	    event void LogRead.readDone(void* buf, storage_len_t len, error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		    if ( (len == sizeof(logentry_t)) && (buf == &m_entry) ) {
		      call Send.send(&m_entry.msg, m_entry.len);
		      call Leds.led1On();
		    }
		    else {
		      if (call LogWrite.erase() != SUCCESS) {
			// Handle error.
		      }
		      call Leds.led0On();
		    }
		  
		 
	 }
	    event void Send.sendDone(message_t* msg, error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		    call Leds.led1Off();
		    if ( (err == SUCCESS) && (msg == &m_entry.msg) ) {
		      call Packet.clear(&m_entry.msg);
		      if (call LogRead.read(&m_entry, sizeof(logentry_t)) != SUCCESS) {
			// Handle error.
		      }
		    }
		    else {
		      call Timer0.startOneShot(INTER_PACKET_INTERVAL);
		    }
		  
		 
	 }
	    event void Timer0.fired() {
	   /* event content */
	   
		   /* event content */
		   
		    call Send.send(&m_entry.msg, m_entry.len);
		  
		 
	 }
	    event void LogWrite.eraseDone(error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		    if (err == SUCCESS) {
		      m_busy = FALSE;
		    }
		    else {
		      // Handle error.
		    }
		    call Leds.led0Off();
		  
		 
	 }
	    event void message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
	   /* event content */
	   
		   /* event content */
		   
		    call Leds.led2On();
		    if (!m_busy) {
		      m_busy = TRUE;
		      m_entry.len = len;
		      m_entry.msg = *msg;
		      if (call LogWrite.append(&m_entry, sizeof(logentry_t)) != SUCCESS) {
			m_busy = FALSE;
		      }
		    }
		    return msg;
		  
		 
	 }
	    event void LogWrite.appendDone(void* buf, storage_len_t len, 
		                                 bool recordsLost, error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		    m_busy = FALSE;
		    call Leds.led2Off();
		  
		 
	 }
	    event void LogRead.seekDone(error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		  
		 
	 }
	    event void LogWrite.syncDone(error_t err) {
	   /* event content */
	   
		   /* event content */
		   
		  
		 
	 }
	
	}
	
	
	
