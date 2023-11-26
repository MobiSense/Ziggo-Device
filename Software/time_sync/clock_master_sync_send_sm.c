#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "../tsn_drivers/ptp_types.h"
#include "../tsn_drivers/rtc.h"
#include "clock_master_sync_send_sm.h"

static const char* lookup_state_name(ClockMasterSyncSendSMState state) {
    switch (state) {
    	case CMSS_BEFORE_INIT:
    		return "CMSS_BEFORE_INIT";
        case CMSS_INIT:
            return "CMSS_INIT";
        case CMSS_INITIALIZING:
            return "CMSS_INITIALIZING";
        case CMSS_SEND_SYNC_INDICATION:
            return "CMSS_SEND_SYNC_INDICATION";
        case CMSS_REACTION:
            return "CMSS_REACTION";
    }
}

static void print_state_change(ClockMasterSyncSendSMState last_state, ClockMasterSyncSendSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("ClockMasterSyncSendSM: state change from %s to %s.\r\n", last_state_name, current_state_name);
}

PortSyncSync* setPSSyncCMSS(ClockMasterSyncSendSM *sm) {
    PortSyncSync *sdata;
    int ssize = sizeof(PortSyncSync);
    sdata = malloc(ssize);
    sdata->localPortNumber = 0;
    sdata->preciseOriginTimestamp = ptpmsgtimestamp_extendedtimestamp(sm->perPTPInstanceGlobal->masterTime);
    // followUpCorrectionField: have not considered fraction ns and gmRateRatio
    UScaledNs currentTime = get_current_timestamp();
    sdata->followUpCorrectionField = uscaledns_subtract(currentTime, sm->perPTPInstanceGlobal->localTime);
    memcpy(sdata->sourcePortIdentity.clockIdentity, sm->perPTPInstanceGlobal->thisClock, 8);
    sdata->sourcePortIdentity.portNumber = 0;
    sdata->logMessageInterval = sm->perPTPInstanceGlobal->clockMasterLogSyncInterval;
    // sdata->upstreamTxTime = sm->perPTPInstanceGlobal->localTime;
    sdata->upstreamTxTime = currentTime;
    sdata->syncReceiptTimeoutTime.nsec = 0xFFFFFFFFFFFFFFFF;
    sdata->syncReceiptTimeoutTime.nsec_msb = 0xFFFF;
    sdata->syncReceiptTimeoutTime.subns = 0xFFFF;
    sdata->rateRatio = sm->perPTPInstanceGlobal->gmRateRatio;
    sdata->gmTimeBaseIndicator = sm->perPTPInstanceGlobal->clockSourceTimeBaseIndicator;
    sdata->lastGmPhaseChange = sm->perPTPInstanceGlobal->clockSourcePhaseOffset;
    sdata->lastGmFreqChange = sm->perPTPInstanceGlobal->clockSourceFreqOffset;
    sdata->domainNumber = 0;
    return sdata;
}

void txPSSyncCMSS(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    site_sync_sync_sm_recv_pss(sm->site_sync_sync_sm, ts, sm->txPSSyncPtrCMSS);
}

UScaledNs computeClockMasterSyncInterval() {
    // Just return 1 second.
    UScaledNs r;
    r.subns = 0;
    r.nsec = ONE_SEC_NS;
    r.nsec_msb = 0;
    return r;
}

static ClockMasterSyncSendSMState all_state_transition(ClockMasterSyncSendSM *sm) {
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable) {
        printf("clock master sync send sm, all_state_transition takes effect.\r\n");
        return CMSS_INITIALIZING;
    }
    return sm->state;
}

static void initializing_action(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    sm->perPTPInstanceGlobal->clockMasterSyncInterval = computeClockMasterSyncInterval(sm);
    sm->syncSendTime = uscaledns_add(ts, sm->perPTPInstanceGlobal->clockMasterSyncInterval);
}

static ClockMasterSyncSendSMState initializing_state_transition(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    if (uscaledns_compare(ts, sm->syncSendTime) >= 0) {
        return CMSS_SEND_SYNC_INDICATION;
    } else {
        return CMSS_INITIALIZING;
    }
}

static void send_sync_indication_action(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    if (sm->txPSSyncPtrCMSS != NULL) {
        free(sm->txPSSyncPtrCMSS);
    }
    sm->txPSSyncPtrCMSS = setPSSyncCMSS(sm);
    txPSSyncCMSS(sm, ts);
    sm->perPTPInstanceGlobal->clockMasterSyncInterval = computeClockMasterSyncInterval();
    sm->syncSendTime = uscaledns_add(ts, sm->perPTPInstanceGlobal->clockMasterSyncInterval);
}

static ClockMasterSyncSendSMState send_sync_indication_state_transition(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    if (uscaledns_compare(ts, sm->syncSendTime) >= 0) {
        sm->last_state = CMSS_REACTION;
    }
    return CMSS_SEND_SYNC_INDICATION;
}

void clock_master_sync_send_sm_run(ClockMasterSyncSendSM *sm, UScaledNs ts) {
    // printf("Call clock_master_sync_send_sm_run.\r\n");
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        // print_state_change(sm->last_state, sm->state);
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case CMSS_INIT:
                sm->state = CMSS_INITIALIZING;
                break;
            case CMSS_INITIALIZING:
                if (state_change) initializing_action(sm, ts);
                sm->state = initializing_state_transition(sm, ts);
                break;
            case CMSS_SEND_SYNC_INDICATION:
                if (state_change) send_sync_indication_action(sm, ts);
                sm->state = send_sync_indication_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->last_state, sm->state);
    }
}

void init_clock_master_sync_send_sm(ClockMasterSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, SiteSyncSyncSM *site_sync_sync_sm) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->site_sync_sync_sm = site_sync_sync_sm;
    sm->state = CMSS_INIT;
    sm->last_state = CMSS_BEFORE_INIT;
    sm->txPSSyncPtrCMSS = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    clock_master_sync_send_sm_run(sm, ts);
}
