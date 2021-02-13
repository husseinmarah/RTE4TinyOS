	
	configuration TestDisseminationAppC {
	
	}
	implementation {
	components TestDisseminationC;
	components MainC;
	components ActiveMessageC;
	components DisseminationC;
	components new DisseminatorC(uint32_t, 0x1234) as Object32C;
	components new DisseminatorC(uint16_t, 0x2345) as Object16C;
	components LedsC;
	components new TimerMilliC();
	components new TimerMilliC() as TestTimer;
	
	TestDisseminationC.Boot -> MainC;
	TestDisseminationC.RadioControl -> ActiveMessageC;
	TestDisseminationC.DisseminationControl -> DisseminationC;
	TestDisseminationC.Value32 -> Object32C;
	TestDisseminationC.Update32 -> Object32C;
	TestDisseminationC.Value16 -> Object16C;
	TestDisseminationC.Update16 -> Object16C;
	TestDisseminationC.Leds -> LedsC;
	TestDisseminationC.Timer -> TimerMilliC;
	TestDisseminationC.TestTimer -> TestTimer;
	TestDisseminationC.TestRadioControl -> ActiveMessageC;
	
	}
	
	
	
