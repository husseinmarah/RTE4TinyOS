	
	configuration RadioStressAppC {
	
	}
	implementation {
	components MainC;
	components RadioStressC;
	components LedsC;
	components BlockingActiveMessageC;
	components new ThreadC(300) as RadioStressThread0;
	components new BlockingAMSenderC(220) as BlockingAMSender0;
	components new BlockingAMReceiverC(220) as BlockingAMReceiver0;
	components new ThreadC(300) as RadioStressThread1;
	components new BlockingAMSenderC(221) as BlockingAMSender1;
	components new BlockingAMReceiverC(221) as BlockingAMReceiver1;
	components new ThreadC(300) as RadioStressThread2;
	components new BlockingAMSenderC(222) as BlockingAMSender2;
	components new BlockingAMReceiverC(222) as BlockingAMReceiver2;
	components ActiveMessageC;
	
	MainC.Boot <- RadioStressC;
	RadioStressC.BlockingAMControl -> BlockingActiveMessageC;
	RadioStressC.Leds -> LedsC;
	RadioStressC.RadioStressThread0 -> RadioStressThread0;
	RadioStressC.BlockingAMSend0 -> BlockingAMSender0;
	RadioStressC.BlockingReceive0 -> BlockingAMReceiver0;
	RadioStressC.RadioStressThread1 -> RadioStressThread1;
	RadioStressC.BlockingAMSend1 -> BlockingAMSender1;
	RadioStressC.BlockingReceive1 -> BlockingAMReceiver1;
	RadioStressC.RadioStressThread2 -> RadioStressThread2;
	RadioStressC.BlockingAMSend2 -> BlockingAMSender2;
	RadioStressC.BlockingReceive2 -> BlockingAMReceiver2;
	
	}
	
	
	
