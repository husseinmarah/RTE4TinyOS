	
	#include "<MViz.h>"
	
	configuration MVizAppC {
	
	}
	implementation {
	components MainC;
	components MVizC;
	components LedsC;
	components new TimerMilliC();
	components new MVizSensorC() as Sensor;
	components RandomC;
	components CollectionC as Collector;
	components ActiveMessageC;
	components new CollectionSenderC(AM_MVIZ_MSG);
	components SerialActiveMessageC;
	components new SerialAMSenderC(AM_MVIZ_MSG);
	components CtpP as Ctp;
	components new TimerMilliC() as TestTimer;
	components ActiveMessageC;
	
	MVizC.Boot -> MainC;
	MVizC.Timer -> TimerMilliC;
	MVizC.Read -> Sensor;
	MVizC.Leds -> LedsC;
	MVizC.Random -> RandomC;
	MVizC.TestTimer -> TestTimer;
	MVizC.TestRadioControl -> ActiveMessageC;
	MVizC.RadioControl -> ActiveMessageC;
	MVizC.SerialControl -> SerialActiveMessageC;
	MVizC.RoutingControl -> Collector;
	MVizC.Send -> CollectionSenderC;
	MVizC.SerialSend -> SerialAMSenderC.AMSend;
	MVizC.Snoop -> Collector.Snoop[AM_MVIZ_MSG];
	MVizC.Receive -> Collector.Receive[AM_MVIZ_MSG];
	MVizC.RootControl -> Collector;
	MVizC.CtpInfo -> Ctp;
	MVizC.LinkEstimator -> Ctp;
	
	}
	
	
	
