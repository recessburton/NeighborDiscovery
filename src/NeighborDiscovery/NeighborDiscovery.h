#ifndef NEIGHBOR_DISCOVERY_H
#define NEIGHBOR_DISCOVERY_H
#include "TossimRadioMsg.h"

enum {
	PROBEMSG = 13,                  //探测包无线信道号
	PROBE_PERIOD_MILLI = 412,		//探测包发送间隔
	MAX_NODE_SIZE = 255,            //最大仿真节点数
};

#endif /* NEIGHBOR_DISCOVERY_H */
