	#include "Timer.h"
	
	module SenseC @safe() {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli>;
	uses interface Read<uint16_t>;
	
	}
	implementation {
	  /* nesc code */
	 #define SAMPLING_FREQUENCY 100
	
	
	
		event void Boot.booted() {
	  /**
	   * event content
	   */
	 }
		event void Timer.fired() {
	  /**
	   * event content
	   */
	 }
		event void Read.readDone(error_t result, uint16_t data) {
	  /**
	   * event content
	   */
	 }
	
	
	
	}
	
	
	
