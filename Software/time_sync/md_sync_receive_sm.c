#include <stdlib.h>
#include "md_sync_receive_sm.h"
#include <stdio.h>

static const char* lookup_state_name(MDSyncReceiveSMState state) {
    switch (state) {
        case MDSR_BEFORE_INIT:
            return "MDSR_BEFORE_INIT";
        case MDSR_INIT:
            return "MDSR_INIT";
        case MDSR_DISCARD:
            return "MDSR_DISCARD";
        case MDSR_WAITING_FOR_FOLLOW_UP:
            return "MDSR_WAITING_FOR_FOLLOW_UP";
        case MDSR_WAITING_FOR_SYNC:
            return "MDSR_WAITING_FOR_SYNC";
        case MDSR_REACTION:
            return "MDSR_REACTION";
    }
}

static void print_state_change(uint16_t portNumber, MDSyncReceiveSMState last_state, MDSyncReceiveSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("MDSyncReceiveSM-%d: state change from %s to %s.\r\n", portNumber, last_state_name, current_state_name);
}

static MDSyncReceive *setMDSyncReceiveMDSR(MDSyncReceiveSM *sm) {
    MDSyncReceive *md_sync_receive_ptr = malloc(sizeof(MDSyncReceive));
    UScaledNs sync_correction = uscaledns_uint64(sm->rcvdSyncPtr->head.correctionField);
    UScaledNs followup_correction = uscaledns_uint64(sm->rcvdFollowUpPtr->head.correctionField);
    md_sync_receive_ptr->followUpCorrectionField = uscaledns_add(sync_correction, followup_correction);
    md_sync_receive_ptr->sourcePortIdentity = sm->rcvdSyncPtr->head.sourcePortIdentity;
    md_sync_receive_ptr->logMessageInterval = sm->rcvdSyncPtr->head.logMessageInterval;
    md_sync_receive_ptr->preciseOriginTimestamp = sm->rcvdFollowUpPtr->preciseOriginTimestamp;
    md_sync_receive_ptr->rateRatio = 1.0; // simplified, should be calculated from cumulativeScaledRateOffset.
    md_sync_receive_ptr->upstreamTxTime = uscaledns_subtract(sm->syncEventIngressTimestamp, sm->perPortGlobal->meanLinkDelay);
    md_sync_receive_ptr->gmTimeBaseIndicator = sm->rcvdFollowUpPtr->followUpInformationTLV.gmTimeBaseIndicator;
    md_sync_receive_ptr->lastGmPhaseChange = sm->rcvdFollowUpPtr->followUpInformationTLV.lastGmPhaseChange;
    md_sync_receive_ptr->lastGmFreqChange = 0.0; // simplified, should be calculated from scaledLastGmFreqChange.
    md_sync_receive_ptr->domainNumber = sm->rcvdSyncPtr->head.domainNumber;
    return md_sync_receive_ptr;
}

static void txMDSyncReceive(MDSyncReceiveSM *sm, UScaledNs ts) {
    port_sync_sync_receive_sm_recv_md_sync(sm->pssr_sm, ts, sm->txMDSyncReceivePtrMDSR);
}

static MDSyncReceiveSMState all_state_transition(MDSyncReceiveSM *sm) {
    bool thirdTerm = sm->rcvdSync && (!sm->perPortGlobal->portOper || !sm->perPortGlobal->ptpPortEnabled || !sm->perPortGlobal->asCapable);
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable || thirdTerm) {
        // printf("md sync receive sm, all state transition to DISCARD.\r\n");
        return MDSR_DISCARD;
    }
    return sm->state;
}

static void discard_action(MDSyncReceiveSM *sm, UScaledNs ts) {
    sm->rcvdSync = 0;
    sm->rcvdFollowUp = 0;
}

static MDSyncReceiveSMState discard_state_transition(MDSyncReceiveSM *sm, UScaledNs ts) {
    bool portValid = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable;
    // printf("call discard_state_transition.\r\n");
    // printf("rcvdSync: %d\r\n", sm->rcvdSync);

    // We ignore two step flag, we only consider two step mode.
    if (sm->rcvdSync && portValid && !sm->perPortGlobal->asymmetryMeasurementMode) {
        return MDSR_WAITING_FOR_FOLLOW_UP;
    } else {
        return MDSR_DISCARD;
    }
}

static void waiting_for_follow_up_action(MDSyncReceiveSM *sm, UScaledNs ts) {
    sm->rcvdSync = 0;
    // simplified, should be calculated from logMessageInterval.
    sm->upstreamSyncInterval.subns = 0;
    sm->upstreamSyncInterval.nsec = ONE_SEC_NS;
    sm->upstreamSyncInterval.nsec_msb = 0;
    sm->followUpReceiptTimeoutTime = uscaledns_add(ts, sm->upstreamSyncInterval);
}

static MDSyncReceiveSMState waiting_for_follow_up_state_transition(MDSyncReceiveSM *sm, UScaledNs ts) {
    bool portValid = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable;
    if (sm->rcvdSync && portValid) {
        sm->last_state = MDSR_REACTION;
        return MDSR_WAITING_FOR_FOLLOW_UP;
    } // && twostepFlag
    if (sm->rcvdFollowUp && sm->rcvdFollowUpPtr->head.sequenceId == sm->rcvdSyncPtr->head.sequenceId) {
        return MDSR_WAITING_FOR_SYNC;
    }
    // ignore twostepflag, assume it is always 1
    if (uscaledns_compare(ts, sm->followUpReceiptTimeoutTime) >= 0 && !sm->perPortGlobal->asymmetryMeasurementMode) {
        return MDSR_DISCARD;
    }
    return MDSR_WAITING_FOR_FOLLOW_UP;
}

static void waiting_for_sync_action(MDSyncReceiveSM *sm, UScaledNs ts) {
    sm->rcvdSync = 0;
    sm->rcvdFollowUp = 0;
    sm->txMDSyncReceivePtrMDSR = setMDSyncReceiveMDSR(sm);
    txMDSyncReceive(sm, ts);
}

static MDSyncReceiveSMState waiting_for_sync_state_transition(MDSyncReceiveSM *sm, UScaledNs ts) {
    bool portValid = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable;
    if (sm->rcvdSync && portValid && !sm->perPortGlobal->asymmetryMeasurementMode) {
        return MDSR_WAITING_FOR_FOLLOW_UP;
    }
    return MDSR_WAITING_FOR_SYNC;
}

void md_sync_receive_sm_run(MDSyncReceiveSM *sm, UScaledNs ts) {
    // printf("call md_sync_receive_sm_run.\r\n");
    // print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case MDSR_INIT:
                sm->state = MDSR_DISCARD;
                break;
            case MDSR_DISCARD:
                if (state_change) discard_action(sm, ts);
                sm->state = discard_state_transition(sm, ts);
                break;
            case MDSR_WAITING_FOR_FOLLOW_UP:
                if (state_change) waiting_for_follow_up_action(sm, ts);
                sm->state = waiting_for_follow_up_state_transition(sm, ts);
                break;
            case MDSR_WAITING_FOR_SYNC:
                if (state_change) waiting_for_sync_action(sm, ts);
                sm->state = waiting_for_sync_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    }
}

void init_md_sync_receive_sm(MDSyncReceiveSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, PortSyncSyncReceiveSM *pssr_sm_ptr) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->perPortGlobal = per_port_global;

    sm->rcvdSyncPtr = NULL;
    sm->rcvdFollowUpPtr = NULL;

    sm->pssr_sm = pssr_sm_ptr;

    sm->state = MDSR_INIT;
    sm->last_state = MDSR_BEFORE_INIT;

    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;

    md_sync_receive_sm_run(sm, ts);
}

void md_sync_receive_sm_recv_sync(MDSyncReceiveSM *sm, UScaledNs ts, TSUTimestamp *tsuTimestamp, PTPMsgSync *sync_msg) {
    if (sm->rcvdSyncPtr != NULL) {
        free(sm->rcvdSyncPtr);
    }
    sm->rcvdSync = 1;
    sm->rcvdSyncPtr = sync_msg;
    sm->syncEventIngressTimestamp = tsuTimestamp->ts;
    free(tsuTimestamp);
    md_sync_receive_sm_run(sm, ts);
}

void md_sync_receive_sm_recv_follow_up(MDSyncReceiveSM *sm, UScaledNs ts, PTPMsgFollowUp *follow_up_msg) {
    if (sm->rcvdFollowUpPtr != NULL) {
        free(sm->rcvdFollowUpPtr);
    }
    sm->rcvdFollowUp = 1;
    sm->rcvdFollowUpPtr = follow_up_msg;
    // printf("MDSyncReceiveSM-%d recv follow up.\r\n", sm->perPortGlobal->thisPort);
    // printf("preciseOriginTimestamp: ");
    // print_uscaledns(uscaledns_ptpmsgtimestamp(follow_up_msg->preciseOriginTimestamp));
    md_sync_receive_sm_run(sm, ts);
}