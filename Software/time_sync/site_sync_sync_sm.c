#include <stdio.h>
#include "site_sync_sync_sm.h"
#include "stdlib.h"

static const char* lookup_state_name(SiteSyncSyncSMState state) {
    switch (state) {
        case SSS_INIT:
            return "SSS_INIT";
        case SSS_INITIALIZING:
            return "SSS_INITIALIZING";
        case SSS_RECEIVING_SYNC:
            return "SSS_RECEIVING_SYNC";
        case SSS_REACTION:
            return "SSS_REACTION";
    }
}

static void print_state_change(SiteSyncSyncSMState last_state, SiteSyncSyncSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("SiteSyncSyncSM: state change from %s to %s.\r\n", last_state_name, current_state_name);
}

static PortSyncSync *setPSSyncSend(SiteSyncSyncSM *sm) {
    PortSyncSync *pss_ptr = malloc(sizeof(PortSyncSync));
    *pss_ptr = *sm->rcvdPSSyncPtrSSS;

    return pss_ptr;
}

static void txPSSync(SiteSyncSyncSM *sm, UScaledNs ts) {
    clock_slave_sync_sm_recv_pss(sm->clock_slave_sync_sm, ts, sm->txPSSyncPtrSSS);
    for (int i = 0; i < N_PORTS; i++) {
        port_sync_sync_send_sm_recv_pss(&sm->port_sync_sync_send_sms[i], ts, sm->txPSSyncPtrSSS);
    }
}

static SiteSyncSyncSMState all_state_transition(SiteSyncSyncSM *sm) {
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable) {
        return SSS_INITIALIZING;
    }
    return sm->state;
}

static void initializing_action(SiteSyncSyncSM *sm, UScaledNs ts) {
    sm->rcvdPSSyncSSS = 0;
}

static SiteSyncSyncSMState initializing_state_transition(SiteSyncSyncSM *sm, UScaledNs ts) {
    if (sm->rcvdPSSyncSSS &&  sm->perPTPInstanceGlobal->selectedState[sm->rcvdPSSyncPtrSSS->localPortNumber] == SLAVE_PORT
    		&& sm->perPTPInstanceGlobal->gmPresent) {
        return SSS_RECEIVING_SYNC;
    } else {
        return SSS_INITIALIZING;
    }
}

static void receiving_sync_action(SiteSyncSyncSM *sm, UScaledNs ts) {
    sm->rcvdPSSyncSSS = 0;
    if (sm->txPSSyncPtrSSS != NULL) {
        free(sm->txPSSyncPtrSSS);
    }
    sm->txPSSyncPtrSSS = setPSSyncSend(sm);
    txPSSync(sm, ts);
    sm->perPTPInstanceGlobal->parentLogSyncInterval = sm->rcvdPSSyncPtrSSS->logMessageInterval;
}

static SiteSyncSyncSMState receiving_sync_state_transition(SiteSyncSyncSM *sm, UScaledNs ts) {
    PortState port_state = sm->perPTPInstanceGlobal->selectedState[sm->rcvdPSSyncPtrSSS->localPortNumber];
    if (sm->rcvdPSSyncSSS && port_state == SLAVE_PORT && sm->perPTPInstanceGlobal->gmPresent) {
        sm->last_state = SSS_REACTION;
    }
    return SSS_RECEIVING_SYNC;
}

void site_sync_sync_sm_run(SiteSyncSyncSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case SSS_INIT:
                sm->state = SSS_INITIALIZING;
                break;
            case SSS_INITIALIZING:
                if (state_change) initializing_action(sm, ts);
                sm->state = initializing_state_transition(sm, ts);
                break;
            case SSS_RECEIVING_SYNC:
                if (state_change) receiving_sync_action(sm, ts);
                sm->state = receiving_sync_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->last_state, sm->state);
    }
}

void site_sync_sync_sm_recv_pss(SiteSyncSyncSM *sm, UScaledNs ts, PortSyncSync *pss_ptr) {
    if (sm->rcvdPSSyncPtrSSS != NULL) {
        free(sm->rcvdPSSyncPtrSSS);
    }
    sm->rcvdPSSyncSSS = 1;
    sm->rcvdPSSyncPtrSSS = malloc(sizeof(PortSyncSync));
    *sm->rcvdPSSyncPtrSSS = *pss_ptr;

    site_sync_sync_sm_run(sm, ts);
}

void init_site_sync_sync_sm(SiteSyncSyncSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, ClockSlaveSyncSM *css_sm, PortSyncSyncSendSM *psss_sms) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->clock_slave_sync_sm = css_sm;
    sm->port_sync_sync_send_sms = psss_sms;
    sm->state = SSS_INIT;
    sm->last_state = SSS_BEFORE_INIT;
    sm->rcvdPSSyncPtrSSS = NULL;
    sm->txPSSyncPtrSSS = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    site_sync_sync_sm_run(sm, ts);
}
