#ifndef CLOCK_SLAVE_SYNC_SM_H
#define CLOCK_SLAVE_SYNC_SM_H

#include <stdio.h>

#include "../tsn_drivers/ptp_types.h"

typedef enum {
    CSS_REACTION,
    CSS_BEFORE_INIT,
    CSS_INIT,
    CSS_INITIALIZING,
    CSS_SEND_SYNC_INDICATION,
} ClockSlaveSyncSMState;

typedef struct ClockSlaveSyncSM {
    bool rcvdPSSyncCSS;
    bool rcvdLocalClockTickCSS;
    PortSyncSync *rcvdPSSyncPtrCSS;

    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    PerPortGlobal *perPortGlobalArray;

    ClockSlaveSyncSMState state;
    ClockSlaveSyncSMState last_state;

    // for neighborRateRatio computation
    UScaledNs lSyncReceiptTime[MAXLENGTH];
    UScaledNs lSyncReceiptLocalTime[MAXLENGTH];
    size_t listHeadPeriod, listTailPeriod;
    bool isEmptyPeriod;
} ClockSlaveSyncSM;

void init_clock_slave_sync_sm(ClockSlaveSyncSM *sm,
                              PerPTPInstanceGlobal *per_ptp_instance_global,
                              PerPortGlobal *per_port_global_array);
void clock_slave_sync_sm_run(ClockSlaveSyncSM *sm, UScaledNs ts);
void clock_slave_sync_sm_recv_pss(ClockSlaveSyncSM *sm, UScaledNs ts,
                                  PortSyncSync *pss_ptr);

#endif