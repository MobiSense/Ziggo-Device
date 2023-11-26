#ifndef MD_SYNC_RECEIVE_SM_H
#define MD_SYNC_RECEIVE_SM_H

#include "../tsn_drivers/ptp_types.h"
#include "port_sync_sync_receive_sm.h"

typedef enum {
    MDSR_REACTION,
    MDSR_BEFORE_INIT,
    MDSR_INIT,
    MDSR_DISCARD,
    MDSR_WAITING_FOR_FOLLOW_UP,
    MDSR_WAITING_FOR_SYNC,
} MDSyncReceiveSMState;

typedef struct MDSyncReceiveSM {
    UScaledNs followUpReceiptTimeoutTime;
    bool rcvdSync;
    bool rcvdFollowUp;
    PTPMsgSync *rcvdSyncPtr;
    PTPMsgFollowUp *rcvdFollowUpPtr;
    MDSyncReceive *txMDSyncReceivePtrMDSR;
    UScaledNs upstreamSyncInterval;

    UScaledNs syncEventIngressTimestamp;

    // MDEntityGlobal *mdEntityGlobal;
    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    PerPortGlobal *perPortGlobal;

    PortSyncSyncReceiveSM *pssr_sm;

    MDSyncReceiveSMState state;
    MDSyncReceiveSMState last_state;
} MDSyncReceiveSM;

void md_sync_receive_sm_recv_follow_up(MDSyncReceiveSM *sm, UScaledNs ts, PTPMsgFollowUp *follow_up_msg);
void md_sync_receive_sm_recv_sync(MDSyncReceiveSM *sm, UScaledNs ts, TSUTimestamp *tsuTimestamp, PTPMsgSync *sync_msg);
void init_md_sync_receive_sm(MDSyncReceiveSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, PortSyncSyncReceiveSM *pssr_sm_ptr);
void md_sync_receive_sm_run(MDSyncReceiveSM *sm, UScaledNs ts);

#endif