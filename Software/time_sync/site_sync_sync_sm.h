#ifndef SITE_SYNC_SYNC_H
#define SITE_SYNC_SYNC_H

#include "../tsn_drivers/ptp_types.h"
#include "clock_slave_sync_sm.h"
#include "port_sync_sync_send_sm.h"

typedef enum {
    SSS_INIT,
    SSS_INITIALIZING,
    SSS_RECEIVING_SYNC,
    SSS_BEFORE_INIT,
    SSS_REACTION,
} SiteSyncSyncSMState;

typedef struct SiteSyncSyncSM {
    // State machine variables
    bool rcvdPSSyncSSS;
    PortSyncSync *rcvdPSSyncPtrSSS;
    PortSyncSync *txPSSyncPtrSSS;

    // Global variables
    PerPTPInstanceGlobal *perPTPInstanceGlobal;

    // Send PortSyncSync to these state machines.
    ClockSlaveSyncSM *clock_slave_sync_sm;
    PortSyncSyncSendSM *port_sync_sync_send_sms;

    SiteSyncSyncSMState state;
    SiteSyncSyncSMState last_state;
} SiteSyncSyncSM;

void site_sync_sync_sm_recv_pss(SiteSyncSyncSM *sm, UScaledNs ts, PortSyncSync *pss_ptr);
void init_site_sync_sync_sm(SiteSyncSyncSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, ClockSlaveSyncSM *css_sm, PortSyncSyncSendSM *psss_sms);

#endif