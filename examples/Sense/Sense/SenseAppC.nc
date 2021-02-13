configuration SenseAppC 
{ 
} 
implementation { 
    components SenseC,
	MainC,
	LedsC,
	new TimerMilliC(),
	new DemoSensorC() as Sensor;
  SenseC.Boot -> MainC;
  SenseC.Leds -> LedsC;
  SenseC.Timer -> TimerMilliC;
  SenseC.Read -> Sensor;
}
