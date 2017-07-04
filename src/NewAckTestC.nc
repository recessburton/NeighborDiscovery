/**
 Copyright (C),2014-2017, YTC, www.bjfulinux.cn
 Copyright (C),2014-2017, ENS Lab, ens.bjfu.edu.cn
 Created on  2017-05-16 15:06
 
 @author: ytc recessburton@gmail.com
 @version: 0.1
 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the University of California nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 **/


#include <Timer.h>
#include "NewAckTest.h"
#include "TossimRadioMsg.h"
#include "AM.h"

module NewAckTestC {
  uses interface Boot;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface NeighborDiscovery;
  
}
implementation {

  uint16_t counter;
  message_t pkt;
  message_t ackMsg;
  bool busy = FALSE;

  event void Boot.booted() {
    call AMControl.start();

  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
    	//if(TOS_NODE_ID % 10==1)
      		//call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
      	call NeighborDiscovery.startNeighborDiscover();
    }else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
   /* counter++;
    if (!busy) {
      BlinkToRadioMsg* btrpkt = 
	(BlinkToRadioMsg*)(call Packet.getPayload(&pkt, sizeof(BlinkToRadioMsg)));
      if (btrpkt == NULL) {
	return;
      }
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->counter = counter;
      dbg("ACK", "Sending id %d...\n", counter);
      call PacketAcknowledgements.requestAck(&pkt);
      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }*/
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    busy = FALSE;
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
      dbg("ACK", "Received id %d.\n", btrpkt->counter);
    }
    return msg;
  }
  
  tossim_header_t* getHeader(message_t* amsg) {
    return (tossim_header_t*)(amsg->data - sizeof(tossim_header_t));
  }
  
  tossim_metadata_t* getMetadata(message_t* amsg) {
    return (tossim_metadata_t*)(&amsg->metadata);
  }
  
  /*

  event void PacketAcknowledgements.PrepareAckAddtionalMsg(message_t* msg){
  	tossim_metadata_t* metadata = getMetadata(msg);
  	tossim_header_t* header = getHeader(msg);
  	metadata->ackNode = TOS_NODE_ID;
  	dbg("YTCT","send ack with nodeid: %d, to %d\n",metadata->ackNode, header->src);
  	if(TOS_NODE_ID == 2){
  		metadata->ack -= 1;
  		dbg("YTCT","Will not send ACK.\n");
  	}
  }
  
  event void PacketAcknowledgements.AckAddtionalMsg(message_t* ackMessage){	
 	tossim_metadata_t* metadata = getMetadata(ackMessage);
 	dbg("YTCT","node %d received ack from %d\n",TOS_NODE_ID, metadata->ackNode);
  }
  */
  	event void NeighborDiscovery.PrepareAckAddtionalMsg(message_t* msg){
  		dbg("YTCT","prp ACK msg %p.\n",msg);
		}
  
	event void NeighborDiscovery.AckAddtionalMsg(message_t* ackMessage){	
		dbg("YTCT","rcv ACK, msg %p.\n", ackMessage);
	}
  
}
