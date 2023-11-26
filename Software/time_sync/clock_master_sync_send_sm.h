#ifndef CLOCK_MASTER_SYNC_SEND_SM_H
#define CLOCK_MASTER_SYNC_SEND_SM_H

#include "../tsn_drivers/ptp_types.h"
#include "site_sync_sync_sm.h"

typedef enum {
    CMSS_REACTION,
    CMSS_BEFORE_INIT,
    CMSS_INIT,
    CMSS_INITIALIZING,
    CMSS_SEND_SYNC_INDICATION,
} ClockMasterSyncSendSMState;

typedef struct ClockMasterSyncSendSM {
    UScaledNs syncSendTime;
    PortSyncSync *txPSSyncPtrCMSS;

    PerPTPInstanceGlobal *perPTPInstanceGlobal;

    SiteSyncSyncSM *site_sync_sync_sm;

    ClockMasterSyncSendSMState state;
    ClockMasterSyncSendSMState last_state;
} ClockMasterSyncSendSM;

void clock_master_sync_send_sm_run(ClockMasterSyncSendSM *sm, UScaledNs ts);
void init_clock_master_sync_send_sm(ClockMasterSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, SiteSyncSyncSM *site_sync_sync_sm);

#endif