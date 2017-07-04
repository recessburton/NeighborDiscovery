#include "NeighborDiscovery.h"
#include <Timer.h>
configuration NeighborDiscoveryC{
	provides{ 
		interface NeighborDiscovery;
	}
}
implementation{
	components NeighborDiscoveryP;
	NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;
	components new TimerMilliC() as packetTimer;
	components new AMSenderC(PROBEMSG) as probeSender; 
	components new AMReceiverC(PROBEMSG) as probeReceiver;
	components ActiveMessageC as RadioControl;
	
	NeighborDiscoveryP.packetTimer        -> packetTimer;
	NeighborDiscoveryP.ProbePacket        -> probeSender;
	NeighborDiscoveryP.ProbeSender        -> probeSender;
	NeighborDiscoveryP.ProbeReceiver      -> probeReceiver;
	NeighborDiscoveryP.probeACKs          -> RadioControl;
	NeighborDiscoveryP.Packet             -> probeSender;
	
	
	
}