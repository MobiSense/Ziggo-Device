#ifndef MD_PDELAY_REQ_SM_H
#define MD_PDELAY_REQ_SM_H
#include <stdio.h>

#include "../tsn_drivers/ptp_types.h"

typedef enum {
    PD_REQ_INIT,
    PD_REQ_NOT_ENABLED,
    PD_REQ_INITIAL_SEND_PDELAY_REQ,
    PD_REQ_WAITING_FOR_PDELAY_RESP,
    PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP,
    PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER,
    PD_REQ_RESET,
    PD_REQ_SEND_PDELAY_REQ,
    PD_REQ_BEFORE_INIT,
} MDPdelayReqSMState;

// 11.2.19 MDPdelayReq state machine
typedef struct MDPdelayReqSM {
    // State machine variables defined in standard.
    UScaledNs pdelayIntervalTimer;
    bool rcvdPdelayResp;
    PTPMsgPdelayResp *rcvdPdelayRespPtr;
    bool rcvdPdelayRespFollowUp;
    PTPMsgPdelayRespFollowUp *rcvdPdelayRespFollowUpPtr;
    PTPMsgPdelayReq *txPdelayReqPtr;
    bool rcvdMDTimestampReceiveMDPReq;
    uint16_t pdelayReqSequenceId;
    uint16_t lostResponses;
    bool neighborRateRatioValid;
    uint16_t detectedFaults;
    bool portEnabled0;

    // Global variables
    PerPortGlobal *perPortGlobal;
    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    MDEntityGlobal *mdEntityGlobal;

    // Other variables
    UScaledNs t1;
    UScaledNs t2;
    UScaledNs t3;
    UScaledNs t4;

    UScaledNs lPdelayRespEventIngressTimestamp[MAXLENGTH];
    UScaledNs lCorrectedResponderEventTimestamp[MAXLENGTH];
    size_t listHeadPropTime, listTailPropTime;
    bool isEmptyPropTime;

    MDPdelayReqSMState state;
    MDPdelayReqSMState last_state;

} MDPdelayReqSM;

void init_md_pdelay_req_sm(MDPdelayReqSM *sm, PerPortGlobal *per_port_global,
                           PerPTPInstanceGlobal *per_ptp_instance_global,
                           MDEntityGlobal *md_entity_global);
void test_md_pdelay_req_sm_send(MDPdelayReqSM *sm);
void md_pdelay_req_sm_run(MDPdelayReqSM *sm, UScaledNs ts);
void md_pdelay_req_sm_txts(MDPdelayReqSM *sm, UScaledNs ts,
                           TSUTimestamp tsuTimestamp);
void md_pdelay_req_sm_recv_resp(MDPdelayReqSM *sm, UScaledNs ts,
                                TSUTimestamp *tsuTimestamp,
                                PTPMsgPdelayResp *pdelayRespPtr);
void md_pdelay_req_sm_recv_resp_follow_up(
    MDPdelayReqSM *sm, UScaledNs ts,
    PTPMsgPdelayRespFollowUp *pdelayRespFollowupPtr);
void md_pdelay_add_resp_and_resp_follow_up_timestamp(MDPdelayReqSM *sm);

#endif
