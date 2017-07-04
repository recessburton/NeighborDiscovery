#include <Timer.h>
#include "TossimRadioMsg.h"
#include "AM.h"
#include "bitArray.h"
#include "NeighborDiscovery.h"

module NeighborDiscoveryP{
	provides interface NeighborDiscovery;
	
	uses interface Timer<TMilli> as packetTimer;
	uses interface Packet as ProbePacket;
	uses interface AMSend as ProbeSender;
	uses interface Receive as ProbeReceiver;
	uses interface PacketAcknowledgements as probeACKs;
	uses interface Packet;
}
implementation{
	
	message_t probepkt;
	bool initialized = FALSE;
	char currentAckedNodeid[BITNSLOTS(MAX_NODE_SIZE)]={0};//在一次probe的send过程中，记录已经回复ack的所有节点
	
	command void NeighborDiscovery.startNeighborDiscover(){
		if(TOS_NODE_ID != 1){
			call packetTimer.startPeriodic(PROBE_PERIOD_MILLI);
		}else{
			initialized = TRUE;
		}
	}
	
	task void sendProbe() {
		//probe为空数据包即可。
		call probeACKs.requestAck(&probepkt);
		call ProbeSender.send(AM_BROADCAST_ADDR, &probepkt, 0);
		dbg("Probe", "%s Probe Send done.\n", sim_time_string());
	}
	
	event void packetTimer.fired() {
		post sendProbe();
	}
	
	event message_t * ProbeReceiver.receive(message_t *msg, void *payload, uint8_t len){
		return msg;
	}

	event void ProbeSender.sendDone(message_t *msg, error_t error){
		//本次send结束，清空暂存的ack节点号记录
		int acknum = call probeACKs.wasAcked(msg);
		dbg("Probe", "Acked # %d.\n", acknum);
		CLEARALLBITS(currentAckedNodeid, MAX_NODE_SIZE);
	}
	
	tossim_metadata_t* _getMetadata(message_t* amsg) {
    	return (tossim_metadata_t*)(&amsg->metadata);
	}
	
	event void probeACKs.PrepareAckAddtionalMsg(message_t* msg){
		tossim_metadata_t* metadata = _getMetadata(msg);
		//若EDC还没初始化，则不做都不做。sink一开始就是初始化的
		if(!initialized)
			return;
		//发送ack的操作由系统完成
		dbg("Probe", "%s Sending ACK, msg %p.\n",sim_time_string(),msg);
		metadata->ackNode = (uint8_t)TOS_NODE_ID;
		signal NeighborDiscovery.PrepareAckAddtionalMsg(msg);
	}
  
	event void probeACKs.AckAddtionalMsg(message_t* ackMessage){	
		//节点收到自己probe包的ack
		tossim_metadata_t* metadata = _getMetadata(ackMessage);
		atomic{
		if((NULL == metadata->ackNode) && (metadata->ackNode == 0))
			return;
		if(BITTEST(currentAckedNodeid, (int)metadata->ackNode))//bug: 同时收到同一节点的两个edc,设置currentAckedNodeid解决
			return;
		else
			BITSET(currentAckedNodeid, (int)metadata->ackNode);
		}
		dbg("Probe", "%s Received ACK from %d, msg %p.\n",sim_time_string(),metadata->ackNode, ackMessage);
		dbg("Probe", "%d Initialized.\n",metadata->ackNode);
		initialized = TRUE;
		call packetTimer.stop();
		signal NeighborDiscovery.AckAddtionalMsg(ackMessage);
	}
}