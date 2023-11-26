#include <stdlib.h>
#include "port_sync_sync_receive_sm.h"
#include <stdio.h>

// #define LOG

static const char* lookup_state_name(PortSyncSyncReceiveSMState state) {
    switch (state) {
        case PSSR_INIT:
            return "PSSR_INIT";
        case PSSR_DISCARD:
            return "PSSR_DISCARD";
        case PSSR_RECEIVED_SYNC:
            return "PSSR_RECEIVED_SYNC";
        case PSSR_REACTION:
            return "PSSR_REACTION";
    }
}

static void print_state_change(uint16_t portNumber, PortSyncSyncReceiveSMState last_state, PortSyncSyncReceiveSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    #ifdef LOG
    // printf("PortSyncSyncReceive-%d: state change from %s to %s.\r\n", portNumber, last_state_name, current_state_name);
    #endif
}

static PortSyncSync *setPSSyncPSSR(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    PortSyncSync *pss_ptr = malloc(sizeof(PortSyncSync));
    MDSyncReceive *sr_ptr = sm->rcvdMDSyncPtrPSSR;
    pss_ptr->localPortNumber = sm->perPortGlobal->thisPort;
    pss_ptr->domainNumber = sr_ptr->domainNumber;
    pss_ptr->followUpCorrectionField = sr_ptr->followUpCorrectionField;
    pss_ptr->sourcePortIdentity = sr_ptr->sourcePortIdentity;
    pss_ptr->logMessageInterval = sr_ptr->logMessageInterval;
    pss_ptr->preciseOriginTimestamp = sr_ptr->preciseOriginTimestamp;
    pss_ptr->upstreamTxTime = sr_ptr->upstreamTxTime;
    pss_ptr->syncReceiptTimeoutTime = uscaledns_add(ts, sm->perPortGlobal->syncReceiptTimeoutTimeInterval);
    pss_ptr->rateRatio = sm->rateRatio;
    return pss_ptr;
}

static void txPSSyncPSSR(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    site_sync_sync_sm_recv_pss(sm->site_sync_sync_sm, ts, sm->txPSSyncPtrPSSR);
}

static PortSyncSyncReceiveSMState all_state_transition(PortSyncSyncReceiveSM *sm) {
    bool third_term = sm->rcvdMDSyncPSSR && (!sm->perPortGlobal->portOper || !sm->perPortGlobal->ptpPortEnabled || !sm->perPortGlobal->asCapable);
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable || third_term) {
        return PSSR_DISCARD;
    }
    return sm->state;
}

static void discard_action(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    sm->rcvdMDSyncPSSR = 0;
}

static PortSyncSyncReceiveSMState discard_state_transition(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    if (sm->rcvdMDSyncPSSR && sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable) {
        return PSSR_RECEIVED_SYNC;
    } else {
        return PSSR_DISCARD;
    }
}

static void received_sync_action(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    sm->rcvdMDSyncPSSR = 0;
    sm->rateRatio = 1.0; // simplified.
    // syncReceiptTimeoutTimeInterval modified. 802.1AS p87.
    sm->perPortGlobal->syncReceiptTimeoutTimeInterval.subns = 0;
    sm->perPortGlobal->syncReceiptTimeoutTimeInterval.nsec_msb = 0;
    sm->perPortGlobal->syncReceiptTimeoutTimeInterval.nsec = ONE_SEC_NS * sm->perPortGlobal->syncReceiptTimeout;
    sm->txPSSyncPtrPSSR = setPSSyncPSSR(sm, ts);
    txPSSyncPSSR(sm, ts);
}

static PortSyncSyncReceiveSMState received_sync_state_transition(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    bool and_part1 = sm->rcvdMDSyncPSSR && sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled;
    bool and_part2 = sm->perPortGlobal->asCapable && !sm->perPortGlobal->asymmetryMeasurementMode;
    // We have skipped the check of gmPriority.sourcePortIdentity.
    if (and_part1 && and_part2) {
        sm->last_state = PSSR_REACTION;
    }
    return PSSR_RECEIVED_SYNC;
}

void port_sync_sync_receive_sm_run(PortSyncSyncReceiveSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case PSSR_INIT:
                sm->state = PSSR_DISCARD;
                break;
            case PSSR_DISCARD:
                if (state_change) discard_action(sm, ts);
                sm->state = discard_state_transition(sm, ts);
                break;
            case PSSR_RECEIVED_SYNC:
                if (state_change) received_sync_action(sm, ts);
                sm->state = received_sync_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    }
}

void port_sync_sync_receive_sm_recv_md_sync(PortSyncSyncReceiveSM *sm, UScaledNs ts, MDSyncReceive *md_sync_ptr) {
    if (sm->rcvdMDSyncPtrPSSR != NULL) {
        free(sm->rcvdMDSyncPtrPSSR);
    }
    sm->rcvdMDSyncPSSR = 1;
    sm->rcvdMDSyncPtrPSSR = md_sync_ptr;

    // printf("PortSyncSyncReceiveSM-%d recv md sync. \r\n", sm->perPortGlobal->thisPort);
    // printf("PreciseOriginTimestamp: ");
    // print_uscaledns(uscaledns_ptpmsgtimestamp(md_sync_ptr->preciseOriginTimestamp));
    // printf("FollowUpCorrectionField: ");
    // print_uscaledns(md_sync_ptr->followUpCorrectionField);

    port_sync_sync_receive_sm_run(sm, ts);
}

void init_port_sync_sync_receive_sm(PortSyncSyncReceiveSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, SiteSyncSyncSM *sss_sm) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->perPortGlobal = per_port_global;
    sm->site_sync_sync_sm = sss_sm;
    sm->last_state = PSSR_BEFORE_INIT;
    sm->state = PSSR_INIT;
    sm->rateRatio = 1.0;
    sm->rcvdMDSyncPtrPSSR = NULL;
    sm->txPSSyncPtrPSSR = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    port_sync_sync_receive_sm_run(sm, ts);
}
