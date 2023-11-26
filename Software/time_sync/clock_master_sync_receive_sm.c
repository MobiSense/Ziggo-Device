#include <stdlib.h>
#include <stdio.h>
#include "clock_master_sync_receive_sm.h"
#include "../tsn_drivers/rtc.h"

// #define LOG

static const char* lookup_state_name(ClockMasterSyncReceiveSMState state) {
    switch (state) {
        case CMSR_INIT:
            return "CMSR_INIT";
        case CMSR_INITIALIZING:
            return "CMSR_INITIALIZING";
        case CMSR_RECEIVE_SOURCE_TIME:
            return "CMSR_RECEIVE_SOURCE_TIME";
        case CMSR_REACTION:
            return "CMSR_REACTION";
    }
}

static void print_state_change(ClockMasterSyncReceiveSMState last_state, ClockMasterSyncReceiveSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    #ifdef LOG
    // printf("ClockMasterSyncReceiveSM: state change from %s to %s.\r\n", last_state_name, current_state_name);
    #endif
}

static double computeGmRateRatio(ClockMasterSyncReceiveSM *sm) {
    // ClockSource and LocalClock is the same in our current implementation.
    // Just set 1.0
    sm->perPTPInstanceGlobal->gmRateRatio = 1.0;
}

static UScaledNs updateMasterTime(ClockMasterSyncReceiveSM *sm) {
    // Only consider recv ClockSourceReq
    // if (sm->rcvdClockSourceReq) {
    sm->perPTPInstanceGlobal->masterTime = sm->rcvdClockSourceReqPtr->sourceTime;
    return sm->perPTPInstanceGlobal->masterTime;
    // }
}

static ClockMasterSyncReceiveSMState all_state_transition(ClockMasterSyncReceiveSM *sm) {
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable) {
        return CMSR_INITIALIZING;
    }
    return sm->state;
}

static void initializing_action(ClockMasterSyncReceiveSM *sm, UScaledNs ts) {
    // Set to 0;
    sm->perPTPInstanceGlobal->masterTime.nsec_msb = 0;
    sm->perPTPInstanceGlobal->masterTime.nsec = 0;
    sm->perPTPInstanceGlobal->masterTime.subns = 0;

    sm->perPTPInstanceGlobal->localTime.nsec_msb = 0;
    sm->perPTPInstanceGlobal->localTime.nsec = 0;
    sm->perPTPInstanceGlobal->localTime.subns = 0;

    sm->perPTPInstanceGlobal->clockSourceTimeBaseIndicatorOld = 0;

    sm->rcvdClockSourceReq = 0;
    sm->rcvdLocalClockTickCMSR = 0;
}

static ClockMasterSyncReceiveSMState initializing_state_transition(ClockMasterSyncReceiveSM *sm, UScaledNs ts) {
    if (sm->rcvdClockSourceReq || sm->rcvdLocalClockTickCMSR) {
        return CMSR_RECEIVE_SOURCE_TIME;
    } else {
        return CMSR_INITIALIZING;
    }
}

static void receive_source_time_action(ClockMasterSyncReceiveSM *sm, UScaledNs ts) {
    UScaledNs current_ts = updateMasterTime(sm);
    sm->perPTPInstanceGlobal->localTime = current_ts;
    if (sm->rcvdClockSourceReq) {
        computeGmRateRatio(sm);
        sm->perPTPInstanceGlobal->clockSourceTimeBaseIndicatorOld = sm->perPTPInstanceGlobal->clockSourceTimeBaseIndicator;
        sm->perPTPInstanceGlobal->clockSourceTimeBaseIndicator = sm->rcvdClockSourceReqPtr->timeBaseIndicator;
        sm->rcvdClockSourceReqPtr->lastGmPhaseChange = sm->rcvdClockSourceReqPtr->lastGmPhaseChange;
        sm->rcvdClockSourceReqPtr->lastGmFreqChange = sm->rcvdClockSourceReqPtr->lastGmFreqChange;
    }
    sm->rcvdClockSourceReq = 0;
    sm->rcvdLocalClockTickCMSR = 0;
}

static ClockMasterSyncReceiveSMState receive_source_time_state_transition(ClockMasterSyncReceiveSM *sm, UScaledNs ts) {
    if (sm->rcvdClockSourceReq || sm->rcvdLocalClockTickCMSR) {
        sm->last_state = CMSR_REACTION;
    }
    return CMSR_RECEIVE_SOURCE_TIME;
}

void clock_master_sync_receive_sm_run(ClockMasterSyncReceiveSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case CMSR_INIT:
                sm->state = CMSR_INITIALIZING;
                break;
            case CMSR_INITIALIZING:
                if (state_change) initializing_action(sm, ts);
                sm->state = initializing_state_transition(sm, ts);
                break;
            case CMSR_RECEIVE_SOURCE_TIME:
                if (state_change) receive_source_time_action(sm, ts);
                sm->state = receive_source_time_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->last_state, sm->state);
    }
}

void init_clock_master_sync_receive_sm(ClockMasterSyncReceiveSM *sm, PerPTPInstanceGlobal *per_pip_instance_global) {
    sm->perPTPInstanceGlobal = per_pip_instance_global;
    sm->last_state = CMSR_BEFORE_INIT;
    sm->state = CMSR_INIT;
    sm->rcvdClockSourceReqPtr = NULL;
    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;
    clock_master_sync_receive_sm_run(sm, ts);
}

void clock_master_sync_receive_sm_recv_source_time(ClockMasterSyncReceiveSM *sm, ClockSourceTimeInvoke *source_time_req, UScaledNs ts) {
    if (sm->rcvdClockSourceReqPtr != NULL) {
        free(sm->rcvdClockSourceReqPtr);
    }
    sm->rcvdClockSourceReq = 1;
    sm->rcvdClockSourceReqPtr = source_time_req;
    clock_master_sync_receive_sm_run(sm, ts);
}