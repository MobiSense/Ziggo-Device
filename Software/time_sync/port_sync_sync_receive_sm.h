#ifndef PORT_SYNC_SYNC_RECEIVE_SM_H
#define PORT_SYNC_SYNC_RECEIVE_SM_H

#include "../tsn_drivers/ptp_types.h"
#include "site_sync_sync_sm.h"

typedef enum {
    PSSR_REACTION,
    PSSR_BEFORE_INIT,
    PSSR_INIT,
    PSSR_DISCARD,
    PSSR_RECEIVED_SYNC,
} PortSyncSyncReceiveSMState;

typedef struct PortSyncSyncReceiveSM {
    bool rcvdMDSyncPSSR;
    MDSyncReceive *rcvdMDSyncPtrPSSR;
    PortSyncSync *txPSSyncPtrPSSR;
    double rateRatio;

    // PerPTPInstanceGlobal *perPTPInstanceGlobal;
    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    PerPortGlobal *perPortGlobal;

    SiteSyncSyncSM *site_sync_sync_sm;

    PortSyncSyncReceiveSMState state;
    PortSyncSyncReceiveSMState last_state;
} PortSyncSyncReceiveSM;

void init_port_sync_sync_receive_sm(PortSyncSyncReceiveSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, SiteSyncSyncSM *sss_sm);
void port_sync_sync_receive_sm_recv_md_sync(PortSyncSyncReceiveSM *sm, UScaledNs ts, MDSyncReceive *md_sync_ptr);
void port_sync_sync_receive_sm_run(PortSyncSyncReceiveSM *sm, UScaledNs ts);

#endif