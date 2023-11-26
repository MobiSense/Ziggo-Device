#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "port_sync_sync_send_sm.h"

static const char* lookup_state_name(PortSyncSyncSendSMState state) {
    switch (state) {
        case PSSS_INIT:
            return "PSSS_INIT";
        case PSSS_TRANSMIT_INIT:
            return "PSSS_TRANSMIT_INIT";
        case PSSS_SYNC_RECEIPT_TIMEOUT:
            return "PSSS_SYNC_RECEIPT_TIMEOUT";
        case PSSS_SEND_MD_SYNC:
            return "PSSS_SEND_MD_SYNC";
        case PSSS_REACTION:
            return "PSSS_REACTION";
    }
}

static void print_state_change(uint16_t portNumber, PortSyncSyncSendSMState last_state, PortSyncSyncSendSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("PortSyncSyncSend-%d: state change from %s to %s.\r\n", portNumber, last_state_name, current_state_name);
}

static MDSyncSend *setMDSync(PortSyncSyncSendSM *sm) {
    MDSyncSend *md_sync_ptr = malloc(sizeof(MDSyncSend));
    md_sync_ptr->sourcePortIdentity.portNumber = sm->perPortGlobal->thisPort;
    memcpy(md_sync_ptr->sourcePortIdentity.clockIdentity, sm->perPTPInstanceGlobal->thisClock, 8);
    md_sync_ptr->logMessageInterval = sm->perPortGlobal->currentLogSyncInterval;
    md_sync_ptr->preciseOriginTimestamp = sm->lastPreciseOriginTimestamp;
    md_sync_ptr->rateRatio = sm->lastRateRatio;
    md_sync_ptr->followUpCorrectionField = sm->lastFollowUpCorrectionField;
    md_sync_ptr->upstreamTxTime = sm->lastUpstreamTxTime;
    md_sync_ptr->gmTimeBaseIndicator = sm->lastGmTimeBaseIndicator;
    md_sync_ptr->lastGmPhaseChange = sm->lastGmPhaseChangePSSS;
    md_sync_ptr->lastGmFreqChange = sm->lastGmFreqChangePSSS;
    md_sync_ptr->domainNumber = 0;
    return md_sync_ptr;
}

static void txMDSync(PortSyncSyncSendSM *sm, UScaledNs ts) {
    // printf("Not implemented.\r\n");
    md_sync_send_sm_recv_md_sync(sm->md_sync_send_sm, ts, sm->txMDSyncPtr);
}

static PortSyncSyncSendSMState all_state_transition(PortSyncSyncSendSM *sm) {
    bool third_item = sm->rcvdPSSyncPSSS && (!sm->perPortGlobal->portOper || !sm->perPortGlobal->ptpPortEnabled || !sm->perPortGlobal->asCapable);
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable || third_item) {
        return PSSS_TRANSMIT_INIT;
    }
    return sm->state;
}

static void transmit_init_action(PortSyncSyncSendSM *sm, UScaledNs ts) {
    sm->rcvdPSSyncPSSS = 0;
    sm->perPortGlobal->syncSlowDown = 0;
    sm->numberSyncTransmissions = 0;
}

static PortSyncSyncSendSMState transmit_init_state_transition(PortSyncSyncSendSM *sm, UScaledNs ts) {
    bool part1 = sm->rcvdPSSyncPSSS && sm->rcvdPSSyncPtrPSSS->localPortNumber != sm->perPortGlobal->thisPort;
    bool part2 = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable;
    if (part1 && part2 && sm->perPTPInstanceGlobal->selectedState[sm->perPortGlobal->thisPort] == MASTER_PORT) {
        return PSSS_SEND_MD_SYNC;
    } else {
        return PSSS_TRANSMIT_INIT;
    }
}

static void sync_receipt_timeout_action(PortSyncSyncSendSM *sm, UScaledNs ts) {
    sm->rcvdPSSyncPSSS = 0;
}

static PortSyncSyncSendSMState sync_receipt_timeout_state_transition(PortSyncSyncSendSM *sm, UScaledNs ts) {
    bool part1 = sm->rcvdPSSyncPSSS && sm->rcvdPSSyncPtrPSSS->localPortNumber != sm->perPortGlobal->thisPort;
    bool part2 = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable;
    if (part1 && part2 && sm->perPTPInstanceGlobal->selectedState[sm->perPortGlobal->thisPort] == MASTER_PORT) {
        return PSSS_SEND_MD_SYNC;
    } else {
        return PSSS_SYNC_RECEIPT_TIMEOUT;
    }
}

static void send_md_sync_action(PortSyncSyncSendSM *sm, UScaledNs ts) {
    if (sm->rcvdPSSyncPSSS) {
        sm->lastRcvdPortNum = sm->rcvdPSSyncPtrPSSS->localPortNumber;
        sm->lastPreciseOriginTimestamp = sm->rcvdPSSyncPtrPSSS->preciseOriginTimestamp;
        sm->lastFollowUpCorrectionField = sm->rcvdPSSyncPtrPSSS->followUpCorrectionField;
        sm->lastRateRatio = sm->rcvdPSSyncPtrPSSS->rateRatio;
        sm->lastUpstreamTxTime = sm->rcvdPSSyncPtrPSSS->upstreamTxTime;
        sm->lastGmTimeBaseIndicator = sm->rcvdPSSyncPtrPSSS->gmTimeBaseIndicator;
        sm->lastGmPhaseChangePSSS = sm->rcvdPSSyncPtrPSSS->lastGmPhaseChange;
        sm->lastGmFreqChangePSSS = sm->rcvdPSSyncPtrPSSS->lastGmFreqChange;
        sm->perPTPInstanceGlobal->syncReceiptTimeoutTime = sm->rcvdPSSyncPtrPSSS->syncReceiptTimeoutTime;
        sm->perPortGlobal->syncLocked = 1; // Modified/Simplified.
    }
    sm->rcvdPSSyncPSSS = 0;
    sm->lastSyncSentTime = ts;
    if (sm->txMDSyncPtr != NULL) {
        free(sm->txMDSyncPtr);
    }
    sm->txMDSyncPtr = setMDSync(sm);
    txMDSync(sm, ts);
    if (sm->perPortGlobal->syncSlowDown) {
        if (sm->numberSyncTransmissions >= sm->perPortGlobal->syncReceiptTimeout) {
            sm->interval1 = sm->perPortGlobal->syncInterval;
            sm->numberSyncTransmissions = 0;
            sm->perPortGlobal->syncSlowDown = 0;
        } else {
            sm->interval1 = sm->perPortGlobal->oldSyncInterval;
            sm->numberSyncTransmissions++;
        }
    } else {
        sm->numberSyncTransmissions = 0;
        sm->interval1 = sm->perPortGlobal->syncInterval;
    }
}

static PortSyncSyncSendSMState send_md_sync_state_transition(PortSyncSyncSendSM *sm, UScaledNs ts) {
    bool pre_conditions = sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable
        && sm->perPTPInstanceGlobal->selectedState[sm->perPortGlobal->thisPort] == MASTER_PORT;
    bool send_condition1 = sm->rcvdPSSyncPSSS && sm->perPortGlobal->syncLocked 
        && sm->rcvdPSSyncPtrPSSS->localPortNumber != sm->perPortGlobal->thisPort;
    UScaledNs elapsedTime = uscaledns_subtract(ts, sm->lastSyncSentTime);
    bool send_condition2 = !sm->perPortGlobal->syncLocked && uscaledns_compare(elapsedTime, sm->interval1) >= 0
        && sm->lastRcvdPortNum != sm->perPortGlobal->thisPort;
    
    if ((send_condition1 || send_condition2) && pre_conditions) {
        sm->last_state = PSSS_REACTION;
        return PSSS_SEND_MD_SYNC;
    }

    if (uscaledns_compare(ts, sm->perPTPInstanceGlobal->syncReceiptTimeoutTime) && !sm->perPortGlobal->syncLocked) {
        return PSSS_SYNC_RECEIPT_TIMEOUT;
    }

    return PSSS_SEND_MD_SYNC;
}

void port_sync_sync_send_sm_recv_pss(PortSyncSyncSendSM *sm, UScaledNs ts, PortSyncSync *pss_ptr) {
    if (sm->rcvdPSSyncPtrPSSS != NULL) {
        free(sm->rcvdPSSyncPtrPSSS);
    }

    sm->rcvdPSSyncPSSS = 1;
    sm->rcvdPSSyncPtrPSSS = malloc(sizeof(PortSyncSync));
    *sm->rcvdPSSyncPtrPSSS = *pss_ptr;

    port_sync_sync_send_sm_run(sm, ts);
}

void port_sync_sync_send_sm_run(PortSyncSyncSendSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case PSSS_INIT:
                sm->state = PSSS_TRANSMIT_INIT;
                break;
            case PSSS_TRANSMIT_INIT:
                if (state_change) transmit_init_action(sm, ts);
                sm->state = transmit_init_state_transition(sm, ts);
                break;
            case PSSS_SYNC_RECEIPT_TIMEOUT:
                if (state_change) sync_receipt_timeout_action(sm, ts);
                sm->state = sync_receipt_timeout_state_transition(sm, ts);
                break;
            case PSSS_SEND_MD_SYNC:
                if (state_change) send_md_sync_action(sm, ts);
                sm->state = send_md_sync_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    }
}

void init_port_sync_sync_send_sm(PortSyncSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, MDSyncSendSM *md_sync_send_sm_ptr) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->perPortGlobal = per_port_global;
    sm->md_sync_send_sm = md_sync_send_sm_ptr;
    sm->last_state = PSSS_BEFORE_INIT;
    sm->state = PSSS_INIT;
    sm->rcvdPSSyncPtrPSSS = NULL;
    sm->txMDSyncPtr = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    port_sync_sync_send_sm_run(sm, ts);
}