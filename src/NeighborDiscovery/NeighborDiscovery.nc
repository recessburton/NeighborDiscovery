interface NeighborDiscovery{
	command void startNeighborDiscover();
	event void  PrepareAckAddtionalMsg(message_t* msg);
	event void  AckAddtionalMsg(message_t* ackMessage);
}