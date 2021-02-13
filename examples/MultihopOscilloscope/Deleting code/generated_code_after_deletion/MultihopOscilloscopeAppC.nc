	
	configuration MultihopOscilloscopeAppC {
	
	}
	implementation {
	components MainC;
	components MultihopOscilloscopeC;
	components LedsC;
	components new TimerMilliC();
	components new DemoSensorC() as Sensor;
	components new TimerMilliC() as TestTimer;
	components ActiveMessageC;
	components CollectionC as Collector;
	components ActiveMessageC;
	components new CollectionSenderC(AM_OSCILLOSCOPE);
	components SerialActiveMessageC;
	components new SerialAMSenderC(AM_OSCILLOSCOPE);
	components new PoolC(message_t, 10) as UARTMessagePoolP;
	components new QueueC(message_t*, 10) as UARTQueueP;
	components new PoolC(message_t, 20) as DebugMessagePool;
	components new QueueC(message_t*, 20) as DebugSendQueue;
	components new SerialAMSenderC(AM_CTP_DEBUG) as DebugSerialSender;
	components UARTDebugSenderP as DebugSender;
	
	MultihopOscilloscopeC.Boot -> MainC;
	MultihopOscilloscopeC.Timer -> TimerMilliC;
	//MultihopOscilloscopeC.Read -> Sensor;
	MultihopOscilloscopeC.Leds -> LedsC;
	MultihopOscilloscopeC.RadioControl -> ActiveMessageC;
	MultihopOscilloscopeC.SerialControl -> SerialActiveMessageC;
	MultihopOscilloscopeC.RoutingControl -> Collector;
	//MultihopOscilloscopeC.Send -> CollectionSenderC;
	MultihopOscilloscopeC.SerialSend -> SerialAMSenderC.AMSend;
	MultihopOscilloscopeC.Snoop -> Collector.Snoop[AM_OSCILLOSCOPE];
	MultihopOscilloscopeC.Receive -> Collector.Receive[AM_OSCILLOSCOPE];
	MultihopOscilloscopeC.RootControl -> Collector;
	MultihopOscilloscopeC.UARTMessagePool -> UARTMessagePoolP;
	MultihopOscilloscopeC.UARTQueue -> UARTQueueP;
	DebugSender.Boot -> MainC;
	DebugSender.UARTSend -> DebugSerialSender;
	DebugSender.MessagePool -> DebugMessagePool;
	DebugSender.SendQueue -> DebugSendQueue;
	Collector.CollectionDebug -> DebugSender;
	
	}
	
	
	
