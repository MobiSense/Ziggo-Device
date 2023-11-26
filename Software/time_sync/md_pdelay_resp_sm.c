#include "md_pdelay_resp_sm.h"
#include "msg_frame.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

static const char* lookup_state_name(MDPdelayRespSMState state) {
    switch (state) {
		case PD_RESP_BEFORE_INIT:
			return "PD_RESP_BEFORE_INIT";
        case PD_RESP_INIT:
            return "PD_RESP_INIT";
        case PD_RESP_NOT_ENABLED:
            return "PD_RESP_NOT_ENABLED";
        case PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ:
            return "PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ";
        case PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP:
            return "PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP";
        case PD_RESP_WAITING_FOR_PDELAY_REQ:
            return "PD_RESP_WAITING_FOR_PDELAY_REQ";
    }
}

static void print_state_change(int portNumber, MDPdelayRespSMState last_state, MDPdelayRespSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("MDPdelayRespSM-%d: state change from %s to %s.\r\n", portNumber, last_state_name, current_state_name);
}

static PTPMsgPdelayResp *setPdelayResp(MDPdelayRespSM *sm)
{
	PTPMsgPdelayResp *sdata;
	int ssize=sizeof(PTPMsgPdelayResp);
    sdata = malloc(ssize);
    PortIdentity sourcePortIdentity;
    uint32_t default_clock_identity_h, default_clock_identity_l;
    default_clock_identity_h = DEFAULT_CLOCK_IDENTITY_H;
    default_clock_identity_l = DEFAULT_CLOCK_IDENTITY_L;
	memcpy(sourcePortIdentity.clockIdentity, &default_clock_identity_h, 4);
	memcpy(sourcePortIdentity.clockIdentity + 4, &default_clock_identity_l, 4);
	sourcePortIdentity.portNumber = sm->perPortGlobal->thisPort;
    uint16_t sequenceId = sm->rcvdPdelayReqPtr->head.sequenceId;
    ptp_msg_header_template(&sdata->head, PDELAY_RESP, sizeof(PTPFramePdelayResp), &sourcePortIdentity, sequenceId,
                DEFAULT_LOG_MESSAGE_INTERVAL, 0);
    sdata->requestReceiptTimestamp = ptpmsgtimestamp_uscaledns(sm->t2);
    sdata->requestingPortIdentity = sm->rcvdPdelayReqPtr->head.sourcePortIdentity;
    return sdata;
}

static void txPdelayResp(MDPdelayRespSM *sm)
{
    PTPFramePdelayResp ptpFramePdelayResp;
    memset(&ptpFramePdelayResp, 0, sizeof(PTPFramePdelayResp));
    set_ptp_frame_header(&ptpFramePdelayResp.head, &sm->txPdelayRespPtr->head);
    memcpy(ptpFramePdelayResp.requestingPortIdentity.clockIdentity, sm->txPdelayRespPtr->requestingPortIdentity.clockIdentity, 8);
    ptpFramePdelayResp.requestingPortIdentity.portNumber = htons(sm->txPdelayRespPtr->requestingPortIdentity.portNumber);
    ptpFramePdelayResp.requestReceiptTimestamp.nanoseconds = htonl(sm->txPdelayRespPtr->requestReceiptTimestamp.nanoseconds);
    ptpFramePdelayResp.requestReceiptTimestamp.seconds_lsb = htonl(sm->txPdelayRespPtr->requestReceiptTimestamp.seconds_lsb);
    ptpFramePdelayResp.requestReceiptTimestamp.seconds_msb = htons(sm->txPdelayRespPtr->requestReceiptTimestamp.seconds_msb);
    send_ptp_frame(&ptpFramePdelayResp, sizeof(PTPFramePdelayResp), sm->perPortGlobal->thisPort, "PDELAY_RESP", sm->txPdelayRespPtr->head.sequenceId);
}

static PTPMsgPdelayRespFollowUp *setPdelayRespFollowUp(MDPdelayRespSM *sm)
{
	PTPMsgPdelayRespFollowUp *sdata;
	int ssize=sizeof(PTPMsgPdelayRespFollowUp);
    sdata = malloc(ssize);
    PortIdentity sourcePortIdentity;
    uint32_t default_clock_identity_h, default_clock_identity_l;
    default_clock_identity_h = DEFAULT_CLOCK_IDENTITY_H;
    default_clock_identity_l = DEFAULT_CLOCK_IDENTITY_L;
	memcpy(sourcePortIdentity.clockIdentity, &default_clock_identity_h, 4);
	memcpy(sourcePortIdentity.clockIdentity + 4, &default_clock_identity_l, 4);
	sourcePortIdentity.portNumber = sm->perPortGlobal->thisPort;
    uint16_t sequenceId = sm->rcvdPdelayReqPtr->head.sequenceId;
    ptp_msg_header_template(&sdata->head, PDELAY_RESP_FOLLOW_UP, sizeof(PTPFramePdelayRespFollowUp), &sourcePortIdentity, sequenceId,
                DEFAULT_LOG_MESSAGE_INTERVAL, 0);
    sdata->responseOriginTimestamp = ptpmsgtimestamp_uscaledns(sm->t3);
    sdata->requestingPortIdentity = sm->rcvdPdelayReqPtr->head.sourcePortIdentity;
    return sdata;
}

static void txPdelayRespFollowUp(MDPdelayRespSM *sm)
{
    PTPFramePdelayRespFollowUp ptpFramePdelayRespFollowUp;
    memset(&ptpFramePdelayRespFollowUp, 0, sizeof(PTPFramePdelayRespFollowUp));
    set_ptp_frame_header(&ptpFramePdelayRespFollowUp.head, &sm->txPdelayRespFollowUpPtr->head);
    memcpy(ptpFramePdelayRespFollowUp.requestingPortIdentity.clockIdentity, sm->txPdelayRespFollowUpPtr->requestingPortIdentity.clockIdentity, 8);
    ptpFramePdelayRespFollowUp.requestingPortIdentity.portNumber = htons(sm->txPdelayRespFollowUpPtr->requestingPortIdentity.portNumber);
    ptpFramePdelayRespFollowUp.responseOriginTimestamp.nanoseconds = htonl(sm->txPdelayRespFollowUpPtr->responseOriginTimestamp.nanoseconds);
    ptpFramePdelayRespFollowUp.responseOriginTimestamp.seconds_lsb = htonl(sm->txPdelayRespFollowUpPtr->responseOriginTimestamp.seconds_lsb);
    ptpFramePdelayRespFollowUp.responseOriginTimestamp.seconds_msb = htons(sm->txPdelayRespFollowUpPtr->responseOriginTimestamp.seconds_msb);
    send_ptp_frame(&ptpFramePdelayRespFollowUp, sizeof(PTPFramePdelayRespFollowUp), sm->perPortGlobal->thisPort, "PDELAY_RESP_FOLLOW_UP", sm->txPdelayRespFollowUpPtr->head.sequenceId);
}

static MDPdelayRespSMState all_state_transition(MDPdelayRespSM *sm)
{
    if(sm->perPTPInstanceGlobal->BEGIN || !sm->perPortGlobal->portOper || !sm->portEnabled1) {
        // printf("MDPdelayRespSM-%d all_state_transition to PD_RESP_NOT_ENABLED.\r\n", sm->perPortGlobal->thisPort);
        return PD_RESP_NOT_ENABLED;
    }
    // printf(lookup_state_name(sm->state));
    return sm->state;
}

static void not_enabled_action(MDPdelayRespSM *sm, UScaledNs ts) {
}

static MDPdelayRespSMState not_enabled_state_transition(MDPdelayRespSM *sm, UScaledNs ts) {
    if (sm->portEnabled1) {
        return PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ;
    } else {
        return PD_RESP_NOT_ENABLED;
    }
}

static void initial_waiting_for_pdelay_req_action(MDPdelayRespSM *sm, UScaledNs ts) {
    sm->rcvdPdelayReq = 0;
    sm->rcvdMDTimestampReceiveMDPResp = 0;
}

static MDPdelayRespSMState initial_waiting_for_pdelay_req_state_transition(MDPdelayRespSM *sm, UScaledNs ts) {
    if (sm->rcvdPdelayReq) {
        return PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP;
    } else {
        return PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ;
    }
}

static void sent_pdelay_resp_waiting_for_timestamp_action(MDPdelayRespSM *sm, UScaledNs ts) {
    sm->rcvdPdelayReq = 0;
    sm->txPdelayRespPtr = setPdelayResp(sm);
    txPdelayResp(sm);
}

static MDPdelayRespSMState sent_pdelay_resp_waiting_for_timestamp_state_transition(MDPdelayRespSM *sm, UScaledNs ts) {
    if (sm->rcvdMDTimestampReceiveMDPResp) {
        return PD_RESP_WAITING_FOR_PDELAY_REQ;
    } else {
        return PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP;
    }
}

static void waiting_for_pdelay_req_action(MDPdelayRespSM *sm, UScaledNs ts) {
    sm->rcvdMDTimestampReceiveMDPResp = 0;
    sm->txPdelayRespFollowUpPtr = setPdelayRespFollowUp(sm);
    txPdelayRespFollowUp(sm);
    free(sm->rcvdPdelayReqPtr);
    free(sm->txPdelayRespPtr);
    free(sm->txPdelayRespFollowUpPtr);
    sm->rcvdPdelayReqPtr = NULL;
    sm->txPdelayRespPtr = NULL;
    sm->txPdelayRespFollowUpPtr = NULL;
}

static MDPdelayRespSMState waiting_for_pdelay_req_state_transition(MDPdelayRespSM *sm, UScaledNs ts) {
    if (sm->rcvdPdelayReq) {
        return PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP;
    } else {
        return PD_RESP_WAITING_FOR_PDELAY_REQ;
    }
}

void md_pdelay_resp_sm_run(MDPdelayRespSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);

    while (1) {
        // print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case PD_RESP_INIT:
                sm->state = PD_RESP_NOT_ENABLED;
                break;
            case PD_RESP_NOT_ENABLED:
                if (state_change) not_enabled_action(sm, ts);
                sm->state = not_enabled_state_transition(sm, ts);
                break;
            case PD_RESP_INITIAL_WAITING_FOR_PDELAY_REQ:
                if (state_change) initial_waiting_for_pdelay_req_action(sm, ts);
                sm->state = initial_waiting_for_pdelay_req_state_transition(sm, ts);
                break;
            case PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP:
                if (state_change) sent_pdelay_resp_waiting_for_timestamp_action(sm, ts);
                sm->state = sent_pdelay_resp_waiting_for_timestamp_state_transition(sm, ts);
                break;
            case PD_RESP_WAITING_FOR_PDELAY_REQ:
                if (state_change) waiting_for_pdelay_req_action(sm, ts);
                sm->state = waiting_for_pdelay_req_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    }
    // if (sm->rcvdPdelayReqPtr != NULL) {
    //     printf("md_pdelay_resp_sm_run-%d check req seq id: %d\r\n", sm->perPortGlobal->thisPort, sm->rcvdPdelayReqPtr->head.sequenceId);
    // } else {
    //     printf("md_pdelay_resp_sm_run-%d check req seq id. rcvdPdelayReqPtr is NULL.\r\n", sm->perPortGlobal->thisPort);
    // }
}

void md_pdelay_resp_sm_txts(MDPdelayRespSM *sm, UScaledNs ts, TSUTimestamp tsuTimestamp) {
    if (sm->state != PD_RESP_SENT_PDELAY_RESP_WAITING_FOR_TIMESTAMP) {
        printf("Timestamp is not expected by MDPdelayRespSM.\r\n");
        return;
    }
    if (tsuTimestamp.sequenceID != sm->rcvdPdelayReqPtr->head.sequenceId) {
        printf("MDPdelayResp-%d Mismatched sequence ID for PdelayResp's TX Timestamp.\r\n", sm->perPortGlobal->thisPort);
        printf("Got Seq ID: %d, Expected %d. \r\n", tsuTimestamp.sequenceID, sm->rcvdPdelayReqPtr->head.sequenceId);
        return;
    }
    // print_uscaledns(tsuTimestamp.ts);
    sm->t3 = tsuTimestamp.ts;
    sm->rcvdMDTimestampReceiveMDPResp = 1;
    md_pdelay_resp_sm_run(sm, ts);
}

void md_pdelay_resp_sm_recv_req(MDPdelayRespSM *sm, UScaledNs ts, TSUTimestamp *tsuTimestamp, PTPMsgPdelayReq *pdelayReqPtr) {
    // printf("MDPdelayRespSM-%d: recv req. Seq ID: %d \r\n", sm->perPortGlobal->thisPort, pdelayReqPtr->head.sequenceId);
    sm->rcvdPdelayReq = 1;
    sm->rcvdPdelayReqPtr = pdelayReqPtr;
    sm->t2 = tsuTimestamp->ts;

    md_pdelay_resp_sm_run(sm, ts);

    free(tsuTimestamp);
}

void init_md_pdelay_resp_sm(MDPdelayRespSM *sm, PerPortGlobal *per_port_global, PerPTPInstanceGlobal *per_ptp_instance_global, MDEntityGlobal *md_entity_global) {
    sm->perPortGlobal = per_port_global;
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->mdEntityGlobal = md_entity_global;
    sm->state = PD_RESP_INIT;
    sm->last_state = PD_RESP_BEFORE_INIT;
    sm->portEnabled1 = 1;
    sm->rcvdPdelayReqPtr = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    md_pdelay_resp_sm_run(sm, ts);
}
