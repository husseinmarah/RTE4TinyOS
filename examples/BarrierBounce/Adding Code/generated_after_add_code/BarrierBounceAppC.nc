	
	#include "barrier_bounce.h"
	
	#include "stack.h"
	
	configuration BarrierBounceAppC {
	
	}
	implementation {
	components MainC, BarrierBounceC as BounceC,  LedsC;
	components BlockingActiveMessageC;
	components new TimerMilliC() as TestTimer;
	components ActiveMessageC;
	components ThreadSynchronizationC;
	components new ThreadC(BOUNCE_THREAD0_STACK_SIZE) as BounceThread0;
	components new BlockingAMSenderC(AM_BOUNCE0_MSG) as BlockingAMSender0;
	components new BlockingAMReceiverC(AM_BOUNCE0_MSG) as BlockingAMReceiver0;
	components new ThreadC(BOUNCE_THREAD1_STACK_SIZE) as BounceThread1;
	components new BlockingAMSenderC(AM_BOUNCE1_MSG) as BlockingAMSender1;
	components new BlockingAMReceiverC(AM_BOUNCE1_MSG) as BlockingAMReceiver1;
	components new ThreadC(BOUNCE_THREAD2_STACK_SIZE) as BounceThread2;
	components new BlockingAMSenderC(AM_BOUNCE2_MSG) as BlockingAMSender2;
	components new BlockingAMReceiverC(AM_BOUNCE2_MSG) as BlockingAMReceiver2;
	components new ThreadC(SYNC_THREAD_STACK_SIZE) as SyncThread;
	
	MainC.Boot <- BounceC;
	BounceC.BlockingAMControl -> BlockingActiveMessageC;
	BounceC.Leds -> LedsC;
	BounceC.TestTimer -> TestTimer;
	BounceC.RadioControl -> ActiveMessageC;
	BounceC.Barrier -> ThreadSynchronizationC;
	BounceC.BounceThread0 -> BounceThread0;
	BounceC.BlockingAMSend0 -> BlockingAMSender0;
	BounceC.BlockingReceive0 -> BlockingAMReceiver0;
	BounceC.BounceThread1 -> BounceThread1;
	BounceC.BlockingAMSend1 -> BlockingAMSender1;
	BounceC.BlockingReceive1 -> BlockingAMReceiver1;
	BounceC.BounceThread2 -> BounceThread2;
	BounceC.BlockingAMSend2 -> BlockingAMSender2;
	BounceC.BlockingReceive2 -> BlockingAMReceiver2;
	BounceC.SyncThread -> SyncThread;
	
	}
	
	
	
