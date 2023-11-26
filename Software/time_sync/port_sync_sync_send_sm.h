#ifndef PORT_SYNC_SYNC_SEND_SM_H
#define PORT_SYNC_SYNC_SEND_SM_H

#include "../tsn_drivers/ptp_types.h"
#include "md_sync_send_sm.h"

typedef enum {
    PSSS_REACTION,
    PSSS_BEFORE_INIT,
    PSSS_INIT,
    PSSS_TRANSMIT_INIT,
    PSSS_SYNC_RECEIPT_TIMEOUT,
    PSSS_SEND_MD_SYNC,
} PortSyncSyncSendSMState;

typedef struct PortSyncSyncSendSM {
    bool rcvdPSSyncPSSS;
    PortSyncSync *rcvdPSSyncPtrPSSS;
    PTPMsgTimestamp lastPreciseOriginTimestamp;
    ScaledNs lastFollowUpCorrectionField;
    double lastRateRatio;
    UScaledNs lastUpstreamTxTime;
    UScaledNs lastSyncSentTime;
    uint16_t lastRcvdPortNum;
    uint16_t lastGmTimeBaseIndicator;
    ScaledNs lastGmPhaseChangePSSS;
    double lastGmFreqChangePSSS;
    MDSyncSend *txMDSyncPtr;
    uint8_t numberSyncTransmissions;
    UScaledNs interval1;

    PerPTPInstanceGlobal *perPTPInstanceGlobal;
    PerPortGlobal *perPortGlobal;

    MDSyncSendSM *md_sync_send_sm;    

    PortSyncSyncSendSMState state;
    PortSyncSyncSendSMState last_state;
} PortSyncSyncSendSM;

void init_port_sync_sync_send_sm(PortSyncSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, MDSyncSendSM *md_sync_send_sm_ptr);
void port_sync_sync_send_sm_run(PortSyncSyncSendSM *sm, UScaledNs ts);
void port_sync_sync_send_sm_recv_pss(PortSyncSyncSendSM *sm, UScaledNs ts, PortSyncSync *pss_ptr);

#endif