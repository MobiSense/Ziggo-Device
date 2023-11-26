#ifndef CLOCK_MASTER_SYNC_RECEIVE_SM_H
#define CLOCK_MASTER_SYNC_RECEIVE_SM_H

#include "../tsn_drivers/ptp_types.h"

typedef enum {
    CMSR_REACTION,
    CMSR_BEFORE_INIT,
    CMSR_INIT,
    CMSR_INITIALIZING,
    CMSR_RECEIVE_SOURCE_TIME,
} ClockMasterSyncReceiveSMState;

typedef struct ClockMasterSyncReceiveSM {
    bool rcvdClockSourceReq;
    ClockSourceTimeInvoke *rcvdClockSourceReqPtr;
    bool rcvdLocalClockTickCMSR;

    PerPTPInstanceGlobal* perPTPInstanceGlobal;

    ClockMasterSyncReceiveSMState state;
    ClockMasterSyncReceiveSMState last_state;
} ClockMasterSyncReceiveSM;

void init_clock_master_sync_receive_sm(ClockMasterSyncReceiveSM *sm, PerPTPInstanceGlobal *per_pip_instance_global);
void clock_master_sync_receive_sm_run(ClockMasterSyncReceiveSM *sm, UScaledNs ts);
void clock_master_sync_receive_sm_recv_source_time(ClockMasterSyncReceiveSM *sm, ClockSourceTimeInvoke *source_time_req, UScaledNs ts);

#endif