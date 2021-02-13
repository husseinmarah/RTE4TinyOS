	
	#include "<Timer.h>"
	
	#include "StorageVolumes.h"
	
	configuration PacketParrotC {
	
	}
	implementation {
	components MainC;
	components LedsC;
	components PacketParrotP as App;
	components ActiveMessageC;
	components CC2420CsmaC;
	components new LogStorageC(VOLUME_LOGTEST, TRUE);
	components new TimerMilliC() as Timer0;
	
	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Packet -> ActiveMessageC;
	App.AMControl -> ActiveMessageC;
	App.Send -> CC2420CsmaC;
	App.Receive -> CC2420CsmaC;
	App.LogRead -> LogStorageC;
	App.LogWrite -> LogStorageC;
	App.Timer0 -> Timer0;
	
	}
	
	
	
