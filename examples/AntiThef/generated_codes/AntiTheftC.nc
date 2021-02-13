//Module File
#include "antitheft.h"
module AntiTheftC @safe() 
{
	uses interface Timer<TMilli> as Check;
	uses interface Read<uint16_t>;
	uses interface ReadStream<uint16_t>;
	uses interface Leds;
	uses interface Boot;
	uses interface Mts300Sounder;
	uses interface DisseminationValue<settings_t> as SettingsValue;
	uses interface Send as AlertRoot;
	uses interface StdControl as CollectionControl;
	uses interface StdControl as DisseminationControl;
	uses interface SplitControl as RadioControl;
	uses interface LowPowerListening;
	uses interface AMSend as TheftSend;
	uses interface Receive as TheftReceive;	
}
implementation 
{
	/* nesc code */
	settings_t settings;
	message_t alertMsg, theftMsg;
	uint16_t ledTime;
	uint16_t accelSamples[ACCEL_SAMPLES];
	void errorLed(){
	}
	void settingsLed(){
	}
	void theftLed(){
	}
	void updateLeds(){
	}
	void check(error_t ok){
	}
	void theft(){
	}
	event void AlertRoot.sendDone(message_t *msg, error_t ok){
	}
	event void TheftSend.sendDone(message_t *msg, error_t ok){
	}
	event void message_t *TheftReceive.receive(message_t* msg, void* payload, uint8_t len){
	}
	event void Boot.booted(){
	}
	event void RadioControl.startDone(error_t ok){
	}
	event void RadioControl.stopDone(error_t ok){
	}
	event void SettingsValue.changed(){
	}
	event void Check.fired(){
	}
	event void Read.readDone(error_t ok, uint16_t val){
		
	}
	event void ReadStream.readDone(error_t ok, uint32_t usActualPeriod){
	}
	event void ReadStream.bufferDone(error_t ok, uint16_t *buf, uint16_t count){
	}	
	task void checkAcceleration(){
	}
	
}



