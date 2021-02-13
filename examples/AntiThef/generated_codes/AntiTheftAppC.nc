//Configuration File
#include "antitheft.h"	
configuration AntiTheftAppC {
}
implementation {
	components AntiTheftRootC;
	components ActiveMessageC;
	components MainC;
	components LedsC;
	components new TimerMilliC() as MyTimer;
	components CC1000CsmaRadioC as Radio;
	components CC2420ActiveMessageC as Radio;
	components ActiveMessageC as Radio;
	components PhotoC();
	components new AccelXStreamC();
	components new SounderC;
	components DisseminationC;
	components CollectionC;
	components new CollectionSenderC(COL_ALERTS) as AlertSender;
	components new AMSenderC(AM_THEFT) as SendTheft;
	components new AMReceiverC(AM_THEFT) as ReceiveTheft;
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
	new DisseminatorC(settings_t, DIS_SETTINGS);	
}



