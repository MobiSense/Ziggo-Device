#ifndef MD_PDELAY_RESP_SM_H
#define MD_PDELAY_RESP_SM_H

#include "../tsn_drivers/ptp_types.h"

typedef enum {
    PD_RESP_INIT,
    PD_RESP_NOT_ENABLED,
    PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ,
    PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP,
    PD_RESP_WAITING_FOR_PDELAY_REQ,
    PD_RESP_BEFORE_INIT, 
} MDPdelayRespSMState;

// 11.2.19 MDPdelayReq state machine
typedef struct MDPdelayRespSM {
    // State machine variables defined in standard.
    bool rcvdPdelayReq;
    bool rcvdMDTimestampReceiveMDPResp;
    PTPMsgPdelayResp *txPdelayRespPtr;
    PTPMsgPdelayRespFollowUp *txPdelayRespFollowUpPtr;
    bool portEnabled1;

    // Global variables
    PerPortGlobal *perPortGlobal;
    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    MDEntityGlobal *mdEntityGlobal;
	
    // Other variables
    PTPMsgPdelayReq *rcvdPdelayReqPtr;
    UScaledNs t2;
    UScaledNs t3;

    MDPdelayRespSMState state;
    MDPdelayRespSMState last_state;
	

} MDPdelayRespSM;

void init_md_pdelay_resp_sm(MDPdelayRespSM *sm, PerPortGlobal *per_port_global, PerPTPInstanceGlobal *per_ptp_instance_global, MDEntityGlobal *md_entity_global);
void md_pdelay_resp_sm_recv_req(MDPdelayRespSM *sm, UScaledNs ts, TSUTimestamp *tsuTimestamp, PTPMsgPdelayReq *pdelayReqPtr);
void md_pdelay_resp_sm_txts(MDPdelayRespSM *sm, UScaledNs ts, TSUTimestamp tsuTimestamp);
void md_pdelay_resp_sm_run(MDPdelayRespSM *sm, UScaledNs ts);


#endif