#ifndef MD_SYNC_SEND_SM_H
#define MD_SYNC_SEND_SM_H

#include "../tsn_drivers/ptp_types.h"

typedef enum {
    MDSS_REACTION,
    MDSS_BEFORE_INIT,
    MDSS_INIT,
    MDSS_INITIALIZING,
    MDSS_SEND_SYNC,
    MDSS_SEND_FOLLOW_UP,   
} MDSyncSendSMState;

typedef struct {
    bool rcvdMDSyncMDSS;
    MDSyncSend *rcvdMDSyncPtr;
    PTPMsgSync *txSyncPtr;
    bool rcvdMDTimestampReceiveMDSS;
    TSUTimestamp *rcvdMDTimestampReceivePtr;
    PTPMsgFollowUp *txFollowUpPtr;

    UScaledNs syncEventEgressTimestamp;

    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    MDEntityGlobal *mdEntityGlobal;
    PerPortGlobal *perPortGlobal;

    MDSyncSendSMState state;
    MDSyncSendSMState last_state;
} MDSyncSendSM;

void init_md_sync_send_sm(MDSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, MDEntityGlobal *md_entity_global);
void md_sync_send_sm_run(MDSyncSendSM *sm, UScaledNs ts);
void md_sync_send_sm_txts(MDSyncSendSM *sm, UScaledNs ts, TSUTimestamp tsuTimestamp);
void md_sync_send_sm_recv_md_sync(MDSyncSendSM *sm, UScaledNs ts, MDSyncSend *md_sync_send_ptr);

#endif