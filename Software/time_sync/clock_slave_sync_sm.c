#include "clock_slave_sync_sm.h"

#include <math.h>
#include <stdio.h>
#include <inttypes.h>

#include "../tsn_drivers/rtc.h"
#include "stdlib.h"
#include "../log/log.h"

static double period = 8;  // default period is 8ns for 125MHz clock frequency

static const char *lookup_state_name(ClockSlaveSyncSMState state) {
    switch (state) {
        case CSS_INIT:
            return "CSS_INIT";
        case CSS_INITIALIZING:
            return "CSS_INITIALIZING";
        case CSS_SEND_SYNC_INDICATION:
            return "CSS_SEND_SYNC_INDICATION";
        case CSS_REACTION:
            return "CSS_REACTION";
    }
}

static void print_state_change(ClockSlaveSyncSMState last_state,
                               ClockSlaveSyncSMState current_state) {
    const char *last_state_name = lookup_state_name(last_state);
    const char *current_state_name = lookup_state_name(current_state);
    // printf("ClockSlaveSyncSM: state change from %s to %s.\r\n", last_state_name,
        //    current_state_name);
}

static void updateSlavePeriod(ClockSlaveSyncSM *sm) {
    log_debug("******Sync Period******:");

    if (sm->isEmptyPeriod == 1 || sm->listHeadPeriod == sm->listTailPeriod) {
        // no need to change period
        return;
    }

    // print_uscaledns(sm->lSyncReceiptTime[sm->listTailPeriod]);
    // print_uscaledns(sm->lSyncReceiptTime[sm->listHeadPeriod]);
    // print_uscaledns(sm->lSyncReceiptLocalTime[sm->listTailPeriod]);
    // print_uscaledns(sm->lSyncReceiptLocalTime[sm->listHeadPeriod]);

    double r = uscaledns_div(
        uscaledns_subtract(sm->lSyncReceiptTime[sm->listTailPeriod],
                           sm->lSyncReceiptTime[sm->listHeadPeriod]),
        uscaledns_subtract(sm->lSyncReceiptLocalTime[sm->listTailPeriod],
                           sm->lSyncReceiptLocalTime[sm->listHeadPeriod]));
    log_debug("neighbor rate ratio: %.6lf", r);

    if (fabs(r - 1.0) < 1e-9) {
        // no need to change period
        // printf("r=%.6lf is too close to 1.0, |r-1|=%.6lf<1e-9\r\n", r,
        //        fabs(r - 1.0));
        log_debug("*********************");
        return;
    }
    // r is meaningless, return
    if (fabs(r - 1) > 1e-3) {
        sm->listHeadPeriod = sm->listTailPeriod;
        return;
    }
    log_debug("old period: %.6lf, new period: %.6lf", period, period * r);

    period *= r;
    uint32_t period_h = (uint32_t)(floor(period));
    uint32_t period_l = 0;
    double t = period - floor(period);
    for (int i = 0; i < 32; i++) {
        if (t * 2 > 1) {
            period_l |= 1 << (31 - i);
            t = t * 2 - 1;
        } else
            t = t * 2;
    }
    // rounding
    if (t * 2 > 1) {
        if (period_l == 0xffffffff) {
            period_l = 0;
            period_h++;
        } else {
            period_l++;
        }
    }
    rtc_set_period(period_h, period_l);
    // CRITICAL STEP: reset list
    sm->listHeadPeriod = sm->listTailPeriod;

    log_debug("*********************");
}

// slaveTime is maintained in hardware (like current time)
// This function is different from the standard. It adjust how hw calculate
// slave time.
static void updateSlaveTime(ClockSlaveSyncSM *sm) {
    UScaledNs offset, sync_ts, local_ts;
    // printf("Just print time offset between local clock and master
    // clock.\r\n");
    
    // UScaledNs offset =
    // uscaledns_subtract(sm->perPTPInstanceGlobal->syncReceiptTime,
    // sm->perPTPInstanceGlobal->syncReceiptLocalTime); UScaledNs sync_time =
    // uscaledns_add(get_current_timestamp(), offset);
    // print_uscaledns(sync_time);

    if (uscaledns_compare(sm->perPTPInstanceGlobal->syncReceiptTime,
                          sm->perPTPInstanceGlobal->syncReceiptLocalTime) >=
        0) {
        // Offset add.
        offset =
            uscaledns_subtract(sm->perPTPInstanceGlobal->syncReceiptTime,
                               sm->perPTPInstanceGlobal->syncReceiptLocalTime);
        set_rtc_sync_offset(RTC_OFFSET_ADD, &offset);
    } else {
        // Offset sub.
        offset =
            uscaledns_subtract(sm->perPTPInstanceGlobal->syncReceiptLocalTime,
                               sm->perPTPInstanceGlobal->syncReceiptTime);
        set_rtc_sync_offset(RTC_OFFSET_SUB, &offset);
    }
    get_current_local_sync_ts(&local_ts, &sync_ts);
    log_info("******Sync Time******: [0x%016" PRIX64 "] ns", sync_ts.nsec);
}

// invodeApplicationInterfaceFunction not implemented.

static ClockSlaveSyncSMState all_state_transition(ClockSlaveSyncSM *sm) {
    if (sm->perPTPInstanceGlobal->BEGIN ||
        !sm->perPTPInstanceGlobal->instanceEnable) {
        return CSS_INITIALIZING;
    }
    return sm->state;
}

static void initializing_action(ClockSlaveSyncSM *sm, UScaledNs ts) {
    sm->rcvdPSSyncCSS = 0;
    sm->rcvdLocalClockTickCSS = 0;
}

static ClockSlaveSyncSMState initializing_state_transition(ClockSlaveSyncSM *sm,
                                                           UScaledNs ts) {
    if (sm->rcvdPSSyncCSS || sm->rcvdLocalClockTickCSS) {
        return CSS_SEND_SYNC_INDICATION;
    } else {
        return CSS_INITIALIZING;
    }
}

static void add_new_syncReceiptTime_syncReceiptLocalTime(ClockSlaveSyncSM *sm) {
    sm->lSyncReceiptTime[(sm->listTailPeriod + 1) % MAXLENGTH] =
        sm->perPTPInstanceGlobal->syncReceiptTime;
    sm->lSyncReceiptLocalTime[(sm->listTailPeriod + 1) % MAXLENGTH] =
        sm->perPTPInstanceGlobal->syncReceiptLocalTime;

    if (sm->isEmptyPeriod) {
        sm->isEmptyPeriod = 0;
    } else if (sm->listHeadPeriod == (sm->listTailPeriod + 1) % MAXLENGTH) {
        // Circular Queue is full
        sm->listHeadPeriod = (sm->listHeadPeriod + 1) % MAXLENGTH;
    }
    sm->listTailPeriod = (sm->listTailPeriod + 1) % MAXLENGTH;
}

static void send_sync_indication_action(ClockSlaveSyncSM *sm, UScaledNs ts) {
    // printf("call send_sync_indication_action, rcvdPSSyncCSS: %d\r\n",
    // sm->rcvdPSSyncCSS);
    if (sm->rcvdPSSyncCSS) {
        // always 1 because we do not consider local clock tick;
        UScaledNs pot = uscaledns_ptpmsgtimestamp(
            sm->rcvdPSSyncPtrCSS->preciseOriginTimestamp);
        UScaledNs fup =
            (UScaledNs)sm->rcvdPSSyncPtrCSS->followUpCorrectionField;
        UScaledNs pot_fup = uscaledns_add(pot, fup);
        UScaledNs mean_link_delay;
        if (sm->rcvdPSSyncPtrCSS->localPortNumber == 0) {
            mean_link_delay.subns = 0;
            mean_link_delay.nsec = 0;
            mean_link_delay.nsec_msb = 0;
        } else {
            mean_link_delay =
                sm->perPortGlobalArray[sm->rcvdPSSyncPtrCSS->localPortNumber -
                                       1]
                    .meanLinkDelay;
        }
        // not consider rate ratio and delay asymmetry.
        // printf("pot_fup: ");
        // print_uscaledns(pot_fup);
        // printf("mean_link_delay: ");
        // print_uscaledns(mean_link_delay);
        sm->perPTPInstanceGlobal->syncReceiptTime =
            uscaledns_add(pot_fup, mean_link_delay);
        sm->perPTPInstanceGlobal->syncReceiptLocalTime = uscaledns_add(
            sm->rcvdPSSyncPtrCSS->upstreamTxTime, mean_link_delay);
        add_new_syncReceiptTime_syncReceiptLocalTime(sm);
        sm->perPTPInstanceGlobal->gmTimeBaseIndicator =
            sm->rcvdPSSyncPtrCSS->gmTimeBaseIndicator;
        sm->perPTPInstanceGlobal->lastGmPhaseChange =
            sm->rcvdPSSyncPtrCSS->lastGmPhaseChange;
        sm->perPTPInstanceGlobal->lastGmFreqChange =
            sm->rcvdPSSyncPtrCSS->lastGmFreqChange;
        // invokeApplicationInterfaceFunction.
        updateSlaveTime(sm);
        updateSlavePeriod(sm);
    }
    sm->rcvdPSSyncCSS = 0;
    sm->rcvdLocalClockTickCSS = 0;
}

static ClockSlaveSyncSMState send_sync_indication_state_transition(
    ClockSlaveSyncSM *sm, UScaledNs ts) {
    if (sm->rcvdPSSyncCSS || sm->rcvdLocalClockTickCSS) {
        sm->last_state = CSS_REACTION;
    }
    return CSS_SEND_SYNC_INDICATION;
}

void clock_slave_sync_sm_recv_pss(ClockSlaveSyncSM *sm, UScaledNs ts,
                                  PortSyncSync *pss_ptr) {
    // printf("call clock slave sync sm recv pss.\r\n");
    if (sm->rcvdPSSyncPtrCSS != NULL) {
        free(sm->rcvdPSSyncPtrCSS);
    }
    sm->rcvdPSSyncCSS = 1;

    sm->rcvdPSSyncPtrCSS = malloc(sizeof(PortSyncSync));
    *sm->rcvdPSSyncPtrCSS = *pss_ptr;

    clock_slave_sync_sm_run(sm, ts);
}

void clock_slave_sync_sm_run(ClockSlaveSyncSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case CSS_INIT:
                sm->state = CSS_INITIALIZING;
                break;
            case CSS_INITIALIZING:
                if (state_change) initializing_action(sm, ts);
                sm->state = initializing_state_transition(sm, ts);
                break;
            case CSS_SEND_SYNC_INDICATION:
                if (state_change) send_sync_indication_action(sm, ts);
                sm->state = send_sync_indication_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state)
            break;
        else
            print_state_change(sm->last_state, sm->state);
    }
}

void init_clock_slave_sync_sm(ClockSlaveSyncSM *sm,
                              PerPTPInstanceGlobal *per_ptp_instance_global,
                              PerPortGlobal *per_port_global_array) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->perPortGlobalArray = per_port_global_array;
    sm->state = CSS_INIT;
    sm->last_state = CSS_BEFORE_INIT;
    sm->rcvdPSSyncPtrCSS = NULL;

    sm->isEmptyPeriod = 1;
    sm->listHeadPeriod = 0;
    sm->listTailPeriod = MAXLENGTH - 1;

    UScaledNs ts;
    ts.subns = 0;
    ts.nsec_msb = 0;
    ts.nsec = 0;
    clock_slave_sync_sm_run(sm, ts);
}