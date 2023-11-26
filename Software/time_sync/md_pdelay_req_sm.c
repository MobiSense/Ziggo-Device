#include "md_pdelay_req_sm.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

#include "../tsn_drivers/rtc.h"
#include "eth_frame.h"
#include "msg_frame.h"
#include "../log/log.h"

static const char *lookup_state_name(MDPdelayReqSMState state) {
    switch (state) {
        case PD_REQ_BEFORE_INIT:
            return "PD_REQ_BEFORE_INIT";
        case PD_REQ_INIT:
            return "PD_REQ_INIT";
        case PD_REQ_NOT_ENABLED:
            return "PD_REQ_NOT_ENABLED";
        case PD_REQ_INITIAL_SEND_PDELAY_REQ:
            return "PD_REQ_INITIAL_SEND_PDELAY_REQ";
        case PD_REQ_WAITING_FOR_PDELAY_RESP:
            return "PD_REQ_WAITING_FOR_PDELAY_RESP";
        case PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP:
            return "PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP";
        case PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER:
            return "PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER";
        case PD_REQ_RESET:
            return "PD_REQ_RESET";
        case PD_REQ_SEND_PDELAY_REQ:
            return "PD_REQ_SEND_PDELAY_REQ";
    }
}

static void print_state_change(int portNumber, MDPdelayReqSMState last_state,
                               MDPdelayReqSMState current_state) {
    const char *last_state_name = lookup_state_name(last_state);
    const char *current_state_name = lookup_state_name(current_state);
    // printf("MDPdelayReqSM-%d: state change from %s to %s.\r\n", portNumber,
        //    last_state_name, current_state_name);
}

static PTPMsgPdelayReq *setPdelayReq(MDPdelayReqSM *sm) {
    PTPMsgPdelayReq *sdata;
    int ssize = sizeof(PTPMsgPdelayReq);
    sdata = malloc(ssize);
    PortIdentity portId;
    uint32_t default_clock_identity_h, default_clock_identity_l;
    default_clock_identity_h = DEFAULT_CLOCK_IDENTITY_H;
    default_clock_identity_l = DEFAULT_CLOCK_IDENTITY_L;
    memcpy(portId.clockIdentity, &default_clock_identity_h, 4);
    memcpy(portId.clockIdentity + 4, &default_clock_identity_l, 4);
    portId.portNumber = sm->perPortGlobal->thisPort;
    ptp_msg_header_template(&sdata->head, PDELAY_REQ, sizeof(PTPFramePdelayReq),
                            &portId, sm->pdelayReqSequenceId,
                            DEFAULT_LOG_MESSAGE_INTERVAL, 0);
    return sdata;
}

static void txPdelayReq(MDPdelayReqSM *sm) {
    PTPFramePdelayReq ptpFramePdelayReq;
    memset(&ptpFramePdelayReq, 0, sizeof(PTPFramePdelayReq));
    set_ptp_frame_header(&ptpFramePdelayReq.head, &sm->txPdelayReqPtr->head);
    send_ptp_frame(&ptpFramePdelayReq, sizeof(PTPFramePdelayReq),
                   sm->perPortGlobal->thisPort, "PDELAY_REQ", sm->txPdelayReqPtr->head.sequenceId);
}

void test_md_pdelay_req_sm_send(MDPdelayReqSM *sm) {
    sm->txPdelayReqPtr = setPdelayReq(sm);
    txPdelayReq(sm);
}

static double computePdelayRateRatio(MDPdelayReqSM *sm) {
    // update 2022/5/30
    //      before: this function return a constant 1.0
    //      after:  return the ratio of the slave LocalClock to the master one
    log_debug("******computePdelayRateRatio******");
    if (sm->isEmptyPropTime || sm->listTailPropTime == sm->listHeadPropTime) {
        return 1.0;
    }
    log_debug("correctedResponderEventTimestamp_N = [0x%016" PRIX64 "] ns", sm->lCorrectedResponderEventTimestamp[sm->listTailPropTime].nsec);
    log_debug("correctedResponderEventTimestamp_0 = [0x%016" PRIX64 "] ns", sm->lCorrectedResponderEventTimestamp[sm->listHeadPropTime].nsec);
    log_debug("pdelayRespEventIngressTimestamp_N  = [0x%016" PRIX64 "] ns", sm->lPdelayRespEventIngressTimestamp[sm->listTailPropTime].nsec);
    log_debug("pdelayRespEventIngressTimestamp_0  = [0x%016" PRIX64 "] ns", sm->lPdelayRespEventIngressTimestamp[sm->listHeadPropTime].nsec);

    double r = uscaledns_div(
        uscaledns_subtract(
            sm->lCorrectedResponderEventTimestamp[sm->listTailPropTime],
            sm->lCorrectedResponderEventTimestamp[sm->listHeadPropTime]),
        uscaledns_subtract(
            sm->lPdelayRespEventIngressTimestamp[sm->listTailPropTime],
            sm->lPdelayRespEventIngressTimestamp[sm->listHeadPropTime]));

    log_debug("neighbor rate ratio: %.6lf", r);

    if (fabs(r - 1) > 1e-3) {
        sm->listHeadPropTime = sm->listTailPropTime;
        r = 1.0;
    }

    log_debug("******************************************");

    return r;
}

static UScaledNs computePropTime(MDPdelayReqSM *sm) {
    log_debug("******computePropTime******");
    log_debug("t1 = [0x%016" PRIX64 "] ns", sm->t1.nsec);
    log_debug("t2 = [0x%016" PRIX64 "] ns", sm->t2.nsec);
    log_debug("t3 = [0x%016" PRIX64 "] ns", sm->t3.nsec);
    log_debug("t4 = [0x%016" PRIX64 "] ns", sm->t4.nsec);
    log_debug("r = %.6lf", sm->perPortGlobal->neighborRateRatio);

    UScaledNs propTime;
    UScaledNs t4_1 = uscaledns_subtract(sm->t4, sm->t1);
    UScaledNs t3_2 = uscaledns_subtract(sm->t3, sm->t2);
    if (uscaledns_compare(sm->t4, sm->t1) < 0) {
        log_error("t4 < t1. t4 = [0x%016" PRIX64 "], t1 = [0x%016" PRIX64 "]", sm->t4.nsec, sm->t1.nsec);
        exit(EXIT_FAILURE);
    }

    log_debug("t4 - t1 = [0x%016" PRIX64 "] ns", t4_1.nsec);
    log_debug("t3 - t2 = [0x%016" PRIX64 "] ns", t3_2.nsec);
   
    UScaledNs r_t4_1 =
        uscaledns_mul_double(t4_1, sm->perPortGlobal->neighborRateRatio);
    // printf("r * (t4 - t1) = ");
    // print_uscaledns(r_t4_1);
    UScaledNs r_t4_1_3_2 = uscaledns_subtract(r_t4_1, t3_2);
    propTime = uscaledns_divide_by_2(r_t4_1_3_2);
    // if (propTime.nsec_msb != 0) {
    //     printf("Unexpected error happens!\n");
    //     exit(EXIT_FAILURE);
    // }
     if (uscaledns_compare(r_t4_1, t3_2) < 0) {
        log_error("Propagation delay is negative. r * (t4 - t1) < (t3 - t2), r * (t4 - t1) = [0x%016" PRIX64 "], t3 - t2 = [0x%016" PRIX64 "]", r_t4_1.nsec, t3_2.nsec);
        exit(EXIT_FAILURE);
    }
    log_debug("propTime = [0x%016" PRIX64 "] ns [0x%04" PRIX16 "] subns", propTime.nsec, propTime.subns);
    log_debug("******************************************");
    return propTime;
}

static MDPdelayReqSMState all_state_transition(MDPdelayReqSM *sm) {
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPortGlobal->portOper ||
        !sm->portEnabled0) {
        // printf("MDPdelayReqSM-%d all_state_transition to
        // PD_REQ_NOT_ENABLED.\r\n", sm->perPortGlobal->thisPort);
        return PD_REQ_NOT_ENABLED;
    }
    // printf(lookup_state_name(sm->state));
    return sm->state;
}

static void not_enabled_action(MDPdelayReqSM *sm, UScaledNs ts) {}

static MDPdelayReqSMState not_enabled_state_transition(MDPdelayReqSM *sm,
                                                       UScaledNs ts) {
    if (sm->perPortGlobal->portOper && sm->portEnabled0) {
        return PD_REQ_INITIAL_SEND_PDELAY_REQ;
    } else {
        return PD_REQ_NOT_ENABLED;
    }
}

static void initial_send_pdelay_req_action(MDPdelayReqSM *sm, UScaledNs ts) {
    // printf("Port %d: initial send pdelay req action.\r\n",
    // sm->perPortGlobal->thisPort);
    sm->rcvdPdelayResp = 0;
    sm->rcvdPdelayRespFollowUp = 0;
    sm->perPortGlobal->neighborRateRatio = 1.0;
    sm->rcvdMDTimestampReceiveMDPReq = 0;
    sm->pdelayReqSequenceId = (uint16_t)(rand() & 0xFFFF);
    sm->txPdelayReqPtr = setPdelayReq(sm);
    txPdelayReq(sm);
    sm->pdelayIntervalTimer = ts;
    sm->lostResponses = 0;
    sm->detectedFaults = 0;
    sm->mdEntityGlobal->isMeasuringDelay = 0;
    sm->mdEntityGlobal->asCapableAcrossDomains = 0;
}

static MDPdelayReqSMState initial_send_pdelay_req_state_transition(
    MDPdelayReqSM *sm, UScaledNs ts) {
    if (sm->rcvdMDTimestampReceiveMDPReq) {
        return PD_REQ_WAITING_FOR_PDELAY_RESP;
    } else {
        return PD_REQ_INITIAL_SEND_PDELAY_REQ;
    }
}

static void reset_action(MDPdelayReqSM *sm, UScaledNs ts) {
    sm->rcvdPdelayResp = 0;
    if (sm->lostResponses <= sm->mdEntityGlobal->allowedLostResponses) {
        sm->lostResponses += 1;
    } else {
        sm->mdEntityGlobal->isMeasuringDelay = 0;
        sm->mdEntityGlobal->asCapableAcrossDomains = 0;
    }
}

static MDPdelayReqSMState reset_state_transition(MDPdelayReqSM *sm,
                                                 UScaledNs ts) {
    UScaledNs elapsedTime = uscaledns_subtract(ts, sm->pdelayIntervalTimer);
    if (uscaledns_compare(elapsedTime, sm->mdEntityGlobal->pdelayReqInterval) >=
        0) {
        return PD_REQ_SEND_PDELAY_REQ;
    } else {
        return PD_REQ_RESET;
    }
}

static void send_pdelay_req_action(MDPdelayReqSM *sm, UScaledNs ts) {
    sm->pdelayReqSequenceId += 1;
    sm->txPdelayReqPtr = setPdelayReq(sm);
    txPdelayReq(sm);
    sm->pdelayIntervalTimer = ts;
}

static MDPdelayReqSMState send_pdelay_req_state_transition(MDPdelayReqSM *sm,
                                                           UScaledNs ts) {
    if (sm->rcvdMDTimestampReceiveMDPReq) {
        return PD_REQ_WAITING_FOR_PDELAY_RESP;
    } else {
        return PD_REQ_SEND_PDELAY_REQ;
    }
}

static void waiting_for_pdelay_resp_action(MDPdelayReqSM *sm, UScaledNs ts) {
    sm->rcvdMDTimestampReceiveMDPReq = 0;
}

static MDPdelayReqSMState waiting_for_pdelay_resp_state_transition(
    MDPdelayReqSM *sm, UScaledNs ts) {
    UScaledNs elapsedTime = uscaledns_subtract(ts, sm->pdelayIntervalTimer);
    if (uscaledns_compare(elapsedTime, sm->mdEntityGlobal->pdelayReqInterval) >=
        0) {
        return PD_REQ_RESET;
    } else {
        if (sm->rcvdPdelayResp) {
            // printf("Check Resp infor.\r\n");
            // printf("Seq ID: %04X vs %04X\r\n",
            //        sm->rcvdPdelayRespPtr->head.sequenceId,
            //        sm->txPdelayReqPtr->head.sequenceId);
            // printf("Port Number: %04X vs %04X\r\n",
            //        sm->rcvdPdelayRespPtr->requestingPortIdentity.portNumber,
            //        sm->perPortGlobal->thisPort);
            if (sm->rcvdPdelayRespPtr->head.sequenceId ==
                    sm->txPdelayReqPtr->head.sequenceId &&
                (!memcmp(
                    sm->rcvdPdelayRespPtr->requestingPortIdentity.clockIdentity,
                    sm->perPTPInstanceGlobal->thisClock, 8)) &&
                (sm->rcvdPdelayRespPtr->requestingPortIdentity.portNumber ==
                 sm->perPortGlobal->thisPort)) {
                return PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP;
            } else {
                printf("Enter PD_REQ_RESET due to infor mismatch.\r\n");
                printf("Seq ID: %04X vs %04X\r\n",
                       sm->rcvdPdelayRespPtr->head.sequenceId,
                       sm->txPdelayReqPtr->head.sequenceId);
                printf("Port Number: %04X vs %04X\r\n",
                       sm->rcvdPdelayRespPtr->requestingPortIdentity.portNumber,
                       sm->perPortGlobal->thisPort);
                return PD_REQ_RESET;
            }
        } else {
            return PD_REQ_WAITING_FOR_PDELAY_RESP;
        }
    }
}

static void waiting_for_pdelay_resp_follow_up_action(MDPdelayReqSM *sm,
                                                     UScaledNs ts) {
    sm->rcvdPdelayResp = 0;
}

static MDPdelayReqSMState waiting_for_pdelay_resp_follow_up_state_transition(
    MDPdelayReqSM *sm, UScaledNs ts) {
    UScaledNs elapsedTime = uscaledns_subtract(ts, sm->pdelayIntervalTimer);
    if (uscaledns_compare(elapsedTime, sm->mdEntityGlobal->pdelayReqInterval) >=
            0 ||
        (sm->rcvdPdelayResp && (sm->rcvdPdelayRespPtr->head.sequenceId ==
                                sm->txPdelayReqPtr->head.sequenceId))) {
        return PD_REQ_RESET;
    }
    if (sm->rcvdPdelayRespFollowUp &&
        (sm->rcvdPdelayRespFollowUpPtr->head.sequenceId ==
         sm->txPdelayReqPtr->head.sequenceId) &&
        (portIdentityEqual(
             sm->rcvdPdelayRespFollowUpPtr->head.sourcePortIdentity,
             sm->rcvdPdelayRespPtr->head.sourcePortIdentity) ||
         (!memcmp(sm->rcvdPdelayRespPtr->requestingPortIdentity.clockIdentity,
                  sm->perPTPInstanceGlobal->thisClock, 8) &&
          sm->rcvdPdelayRespPtr->requestingPortIdentity.portNumber ==
              sm->perPortGlobal->thisPort))) {
        return PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER;
    }
    return PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP;
}

static void waiting_for_pdelay_interval_timer_action(MDPdelayReqSM *sm,
                                                     UScaledNs ts) {
    sm->rcvdPdelayRespFollowUp = 0;
    sm->lostResponses = 0;
    if (!sm->perPortGlobal->asymmetryMeasurementMode) {
        md_pdelay_add_resp_and_resp_follow_up_timestamp(sm);
        if (sm->perPortGlobal->computeNeighborRateRatio) {
            sm->perPortGlobal->neighborRateRatio = computePdelayRateRatio(sm);
        }
        if (sm->perPortGlobal->computeMeanLinkDelay) {
            sm->perPortGlobal->meanLinkDelay = computePropTime(sm);
        }
        sm->mdEntityGlobal->isMeasuringDelay = 1;
        if (uscaledns_compare(sm->perPortGlobal->meanLinkDelay,
                              sm->mdEntityGlobal->meanLinkDelayThresh) <= 0 &&
            memcmp(sm->rcvdPdelayRespPtr->head.sourcePortIdentity.clockIdentity,
                   sm->perPTPInstanceGlobal->thisClock, 8) &&
            sm->neighborRateRatioValid) {
            sm->mdEntityGlobal->asCapableAcrossDomains = 1;
            sm->detectedFaults = 0;
        } else if (memcmp(sm->rcvdPdelayRespPtr->head.sourcePortIdentity
                              .clockIdentity,
                          sm->perPTPInstanceGlobal->thisClock, 8)) {
            sm->mdEntityGlobal->asCapableAcrossDomains = 0;
            sm->detectedFaults = 0;
        } else {
            if (sm->detectedFaults <= sm->mdEntityGlobal->allowedFaults) {
                sm->detectedFaults += 1;
            } else {
                sm->mdEntityGlobal->asCapableAcrossDomains = 0;
                sm->mdEntityGlobal->isMeasuringDelay = 0;
                sm->detectedFaults = 0;
            }
        }
    }
    free(sm->txPdelayReqPtr);
    free(sm->rcvdPdelayRespPtr);
    free(sm->rcvdPdelayRespFollowUpPtr);
}

static MDPdelayReqSMState waiting_for_pdelay_interval_timer_state_transition(
    MDPdelayReqSM *sm, UScaledNs ts) {
    UScaledNs elapsedTime = uscaledns_subtract(ts, sm->pdelayIntervalTimer);
    if (uscaledns_compare(elapsedTime, sm->mdEntityGlobal->pdelayReqInterval) >=
        0) {
        return PD_REQ_SEND_PDELAY_REQ;
    } else {
        return PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER;
    }
}

void md_pdelay_req_sm_run(MDPdelayReqSM *sm, UScaledNs ts) {
    bool state_change;
    // print_state_change(sm->perPortGlobal->thisPort, sm->last_state,
    // sm->state);
    sm->state = all_state_transition(sm);
    // print_state_change(sm->perPortGlobal->thisPort, sm->last_state,
    // sm->state);

    while (1) {
        // print_state_change(sm->perPortGlobal->thisPort, sm->last_state,
        // sm->state);
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case PD_REQ_INIT:
                sm->state = PD_REQ_NOT_ENABLED;
                break;
            case PD_REQ_NOT_ENABLED:
                if (state_change) not_enabled_action(sm, ts);
                sm->state = not_enabled_state_transition(sm, ts);
                break;
            case PD_REQ_INITIAL_SEND_PDELAY_REQ:
                if (state_change) initial_send_pdelay_req_action(sm, ts);
                sm->state = initial_send_pdelay_req_state_transition(sm, ts);
                break;
            case PD_REQ_RESET:
                if (state_change) reset_action(sm, ts);
                sm->state = reset_state_transition(sm, ts);
                break;
            case PD_REQ_SEND_PDELAY_REQ:
                if (state_change) send_pdelay_req_action(sm, ts);
                sm->state = send_pdelay_req_state_transition(sm, ts);
                break;
            case PD_REQ_WAITING_FOR_PDELAY_RESP:
                if (state_change) waiting_for_pdelay_resp_action(sm, ts);
                sm->state = waiting_for_pdelay_resp_state_transition(sm, ts);
                break;
            case PD_REQ_WAITING_FOR_PDELAY_RESP_FOLLOW_UP:
                if (state_change)
                    waiting_for_pdelay_resp_follow_up_action(sm, ts);
                sm->state =
                    waiting_for_pdelay_resp_follow_up_state_transition(sm, ts);
                break;
            case PD_REQ_WAITING_FOR_PDELAY_INTERVAL_TIMER:
                if (state_change)
                    waiting_for_pdelay_interval_timer_action(sm, ts);
                sm->state =
                    waiting_for_pdelay_interval_timer_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state)
            break;
        else
            print_state_change(sm->perPortGlobal->thisPort, sm->last_state,
                               sm->state);
    }
}

void md_pdelay_req_sm_txts(MDPdelayReqSM *sm, UScaledNs ts,
                           TSUTimestamp tsuTimestamp) {
    if (sm->state != PD_REQ_SEND_PDELAY_REQ &&
        sm->state != PD_REQ_INITIAL_SEND_PDELAY_REQ) {
        printf("Timestamp is not expected by MDPdelayReqSM.\r\n");
        return;
    }
    if (tsuTimestamp.sequenceID != sm->pdelayReqSequenceId) {
        printf("Mismatched sequence ID.\r\n");
        return;
    }
    // print_uscaledns(tsuTimestamp.ts);
    sm->t1 = tsuTimestamp.ts;
    sm->rcvdMDTimestampReceiveMDPReq = 1;
    md_pdelay_req_sm_run(sm, ts);
}

void md_pdelay_req_sm_recv_resp(MDPdelayReqSM *sm, UScaledNs ts,
                                TSUTimestamp *tsuTimestamp,
                                PTPMsgPdelayResp *pdelayRespPtr) {
    // printf("enter recv resp. \r\n");
    sm->rcvdPdelayResp = 1;
    sm->rcvdPdelayRespPtr = pdelayRespPtr;
    sm->t2 = uscaledns_ptpmsgtimestamp(pdelayRespPtr->requestReceiptTimestamp);
    // printf("before sm run. \r\n");
    md_pdelay_req_sm_run(sm, ts);
    // printf("after sm run. \r\n");
    sm->t4 = tsuTimestamp->ts;
    free(tsuTimestamp);
}

void md_pdelay_req_sm_recv_resp_follow_up(
    MDPdelayReqSM *sm, UScaledNs ts,
    PTPMsgPdelayRespFollowUp *pdelayRespFollowupPtr) {
    sm->rcvdPdelayRespFollowUp = 1;
    sm->rcvdPdelayRespFollowUpPtr = pdelayRespFollowupPtr;
    sm->t3 = uscaledns_ptpmsgtimestamp(
        pdelayRespFollowupPtr->responseOriginTimestamp);
    md_pdelay_req_sm_run(sm, ts);
}

void init_md_pdelay_req_sm(MDPdelayReqSM *sm, PerPortGlobal *per_port_global,
                           PerPTPInstanceGlobal *per_ptp_instance_global,
                           MDEntityGlobal *md_entity_global) {
    sm->perPortGlobal = per_port_global;
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->mdEntityGlobal = md_entity_global;
    sm->portEnabled0 = 1;
    sm->state = PD_REQ_INIT;
    sm->last_state = PD_REQ_BEFORE_INIT;

    sm->listHeadPropTime = 0;
    sm->listTailPropTime = MAXLENGTH - 1;
    sm->isEmptyPropTime = 1;

    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;

    md_pdelay_req_sm_run(sm, ts);
}

void md_pdelay_add_resp_and_resp_follow_up_timestamp(MDPdelayReqSM *sm) {
    sm->lPdelayRespEventIngressTimestamp[(sm->listTailPropTime + 1) %
                                         MAXLENGTH] = sm->t4;
    sm->lCorrectedResponderEventTimestamp[(sm->listTailPropTime + 1) %
                                          MAXLENGTH] = sm->t3;

    if (sm->isEmptyPropTime) {
        sm->isEmptyPropTime = 0;
    } else if (sm->listHeadPropTime == (sm->listTailPropTime + 1) % MAXLENGTH) {
        // Circular Queue is full
        sm->listHeadPropTime = (sm->listHeadPropTime + 1) % MAXLENGTH;
    }
    sm->listTailPropTime = (sm->listTailPropTime + 1) % MAXLENGTH;
}
