#include "antitheft.h"
configuration AntiTheftAppC {
}
implementation{
	components AntiTheftC,
	ActiveMessageC, 
	MainC, 
	LedsC,
	new TimerMilliC() as MyTimer;
	components new PhotoC(), 
	new AccelXStreamC(),
	SounderC;
	components DisseminationC;
	components CollectionC, 
	new CollectionSenderC(COL_ALERTS) as AlertSender;
	components new AMSenderC(AM_THEFT) as SendTheft, 
	new AMReceiverC(AM_THEFT) as ReceiveTheft;
	components CC1000CsmaRadioC as Radio;
	components CC2420ActiveMessageC as Radio;
	components ActiveMessageC as Radio;
	components new DisseminatorC(settings_t, DIS_SETTINGS);
	AntiTheftC.Boot -> MainC.Boot;
	AntiTheftC.Check -> MyTimer;
	AntiTheftC.Leds -> LedsC;
	AntiTheftC.RadioControl -> ActiveMessageC;
	AntiTheftC.LowPowerListening -> Radio;
	AntiTheftC.Read -> PhotoC;
	AntiTheftC.ReadStream -> AccelXStreamC;
	AntiTheftC.Mts300Sounder -> SounderC;
	AntiTheftC.DisseminationControl -> DisseminationC;
	AntiTheftC.SettingsValue -> DisseminatorC;
	AntiTheftC.AlertRoot -> AlertSender;
	AntiTheftC.CollectionControl -> CollectionC;
	AntiTheftC.TheftSend -> SendTheft;
	AntiTheftC.TheftReceive -> ReceiveTheft;
}
