#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "msg_frame.h"
#include "eth_frame.h"
#include "md_sync_send_sm.h"

static const char* lookup_state_name(MDSyncSendSMState state) {
    switch (state) {
        case MDSS_INIT:
            return "MDSS_INIT";
        case MDSS_INITIALIZING:
            return "MDSS_INITIALIZING";
        case MDSS_SEND_SYNC:
            return "MDSS_SEND_SYNC";
        case MDSS_SEND_FOLLOW_UP:
            return "MDSS_SEND_FOLLOW_UP";
    }
}

static void print_state_change(uint16_t portNumber, MDSyncSendSMState last_state, MDSyncSendSMState current_state) {
    const char* last_state_name = lookup_state_name(last_state);
    const char* current_state_name = lookup_state_name(current_state);
    // printf("MDSyncSendSM-%d: state change from %s to %s.\r\n", portNumber, last_state_name, current_state_name);
}

static PTPMsgSync *setSyncTwoStep(MDSyncSendSM *sm) {
    PTPMsgSync *sync_ptr = malloc(sizeof(PTPMsgSync));
    PortIdentity sourcePortIdentity;
    sourcePortIdentity.portNumber = sm->rcvdMDSyncPtr->sourcePortIdentity.portNumber;
    memcpy(sourcePortIdentity.clockIdentity, sm->rcvdMDSyncPtr->sourcePortIdentity.clockIdentity, 8);
    ptp_msg_header_template(&sync_ptr->head, SYNC, sizeof(PTPFrameSync), &sourcePortIdentity, sm->mdEntityGlobal->syncSequenceId, sm->rcvdMDSyncPtr->logMessageInterval, 0);
    return sync_ptr;
}

static void txSync(MDSyncSendSM *sm) {
    // printf("call txSync.\r\n");
    PTPFrameSync ptpFrameSync;
    memset(&ptpFrameSync, 0, sizeof(PTPFrameSync));
    set_ptp_frame_header(&ptpFrameSync.head, &sm->txSyncPtr->head);
    send_ptp_frame(&ptpFrameSync, sizeof(PTPFrameSync), sm->perPortGlobal->thisPort, "SYNC", sm->txSyncPtr->head.sequenceId);
}

static PTPMsgFollowUp *setFollowUp(MDSyncSendSM *sm) {
    PTPMsgFollowUp *followup_ptr = malloc(sizeof(PTPMsgFollowUp));
    int64_t correction = 0;
    UScaledNs elapsedTime = uscaledns_subtract(sm->syncEventEgressTimestamp, sm->rcvdMDSyncPtr->upstreamTxTime);
    // elapsedTime should be multiplied by rateRatio, here we ignore it.
    UScaledNs correction_uscaledns = uscaledns_add(sm->rcvdMDSyncPtr->followUpCorrectionField, elapsedTime);
    correction = uint64_uscaledns(correction_uscaledns);

    PortIdentity sourcePortIdentity;
    sourcePortIdentity.portNumber = sm->rcvdMDSyncPtr->sourcePortIdentity.portNumber;
    memcpy(sourcePortIdentity.clockIdentity, sm->rcvdMDSyncPtr->sourcePortIdentity.clockIdentity, 8);
    ptp_msg_header_template(&followup_ptr->head, FOLLOW_UP, sizeof(PTPFrameFollowUp), &sourcePortIdentity, sm->txSyncPtr->head.sequenceId, sm->rcvdMDSyncPtr->logMessageInterval, correction);

    followup_ptr->preciseOriginTimestamp = sm->rcvdMDSyncPtr->preciseOriginTimestamp;

    followup_ptr->followUpInformationTLV.tlvType = 0x3;
    followup_ptr->followUpInformationTLV.lengthField = 28;
    followup_ptr->followUpInformationTLV.organizationId[0] = 0x00;
    followup_ptr->followUpInformationTLV.organizationId[1] = 0x80;
    followup_ptr->followUpInformationTLV.organizationId[2] = 0xC2;
    followup_ptr->followUpInformationTLV.organizationSubType[0] = 0x00;
    followup_ptr->followUpInformationTLV.organizationSubType[1] = 0x00;
    followup_ptr->followUpInformationTLV.organizationSubType[2] = 0x01;
    followup_ptr->followUpInformationTLV.cumulativeScaledRateOffset = 0;

    followup_ptr->followUpInformationTLV.gmTimeBaseIndicator = sm->rcvdMDSyncPtr->gmTimeBaseIndicator;
    followup_ptr->followUpInformationTLV.lastGmPhaseChange = sm->rcvdMDSyncPtr->lastGmPhaseChange;
    followup_ptr->followUpInformationTLV.scaledLastGmFreqChange = 0; // simplified.

    return followup_ptr;
}

static void txFollowUp(MDSyncSendSM *sm) {
    PTPFrameFollowUp ptpFrameFollowUp;
    memset(&ptpFrameFollowUp, 0, sizeof(PTPFrameFollowUp));
    set_ptp_frame_header(&ptpFrameFollowUp.head, &sm->txFollowUpPtr->head);

    ptpFrameFollowUp.preciseOriginTimestamp.nanoseconds = htonl(sm->txFollowUpPtr->preciseOriginTimestamp.nanoseconds);
    ptpFrameFollowUp.preciseOriginTimestamp.seconds_lsb = htonl(sm->txFollowUpPtr->preciseOriginTimestamp.seconds_lsb);
    ptpFrameFollowUp.preciseOriginTimestamp.seconds_msb = htons(sm->txFollowUpPtr->preciseOriginTimestamp.seconds_msb);

    ptpFrameFollowUp.followUpInformationTLV.tlvType = htons(sm->txFollowUpPtr->followUpInformationTLV.tlvType);
    ptpFrameFollowUp.followUpInformationTLV.lengthField = htons(sm->txFollowUpPtr->followUpInformationTLV.lengthField);

    memcpy(ptpFrameFollowUp.followUpInformationTLV.organizationId, sm->txFollowUpPtr->followUpInformationTLV.organizationId, 3);
    memcpy(ptpFrameFollowUp.followUpInformationTLV.organizationSubType, sm->txFollowUpPtr->followUpInformationTLV.organizationSubType, 3);

    ptpFrameFollowUp.followUpInformationTLV.cumulativeScaledRateOffset = htonl(sm->txFollowUpPtr->followUpInformationTLV.cumulativeScaledRateOffset);
    ptpFrameFollowUp.followUpInformationTLV.gmTimeBaseIndicator = htons(sm->txFollowUpPtr->followUpInformationTLV.gmTimeBaseIndicator);
    ptpFrameFollowUp.followUpInformationTLV.lastGmPhaseChange.nsec_msb = htons(sm->txFollowUpPtr->followUpInformationTLV.lastGmPhaseChange.nsec_msb);
    ptpFrameFollowUp.followUpInformationTLV.lastGmPhaseChange.nsec = htonll(sm->txFollowUpPtr->followUpInformationTLV.lastGmPhaseChange.nsec);
    ptpFrameFollowUp.followUpInformationTLV.lastGmPhaseChange.subns = htons(sm->txFollowUpPtr->followUpInformationTLV.lastGmPhaseChange.subns);
    ptpFrameFollowUp.followUpInformationTLV.scaledLastGmFreqChange = htonl(sm->txFollowUpPtr->followUpInformationTLV.scaledLastGmFreqChange);

    send_ptp_frame(&ptpFrameFollowUp, sizeof(PTPFrameFollowUp), sm->perPortGlobal->thisPort, "FOLLOW_UP", sm->txFollowUpPtr->head.sequenceId);
}

static MDSyncSendSMState all_state_transition(MDSyncSendSM *sm) {
    bool thirdTerm = sm->rcvdMDSyncMDSS && (!sm->perPortGlobal->portOper || !sm->perPortGlobal->ptpPortEnabled || !sm->perPortGlobal->asCapable);
    if (sm->perPTPInstanceGlobal->BEGIN || !sm->perPTPInstanceGlobal->instanceEnable || thirdTerm) {
        return MDSS_INITIALIZING;
    }
    return sm->state;
}

static void initializing_action(MDSyncSendSM *sm, UScaledNs ts) {
    sm->rcvdMDSyncMDSS = 0;
    sm->rcvdMDTimestampReceiveMDSS = 0;
    sm->mdEntityGlobal->syncSequenceId = (uint16_t) (rand() & 0xFFFF);
}

static MDSyncSendSMState initializing_state_transition(MDSyncSendSM *sm, UScaledNs ts) {
    // We only consider two step sync.
    if (sm->rcvdMDSyncMDSS && sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable && !sm->perPortGlobal->asymmetryMeasurementMode) {
        // printf("call initalizing_state_transition, return MDSS_SEND_SYNC.\r\n");
        return MDSS_SEND_SYNC;
    } else {
        // printf("call initalizing_state_transition, return MDSS_INITIALIZING.\r\n");
        // printf("rcvdMDSyncMDSS: %d, portOper: %d, ptpPortEnabled: %d, asCapable: %d, asymmetryMeasurementMode %d\r\n"
        //    , sm->rcvdMDSyncMDSS, sm->perPortGlobal->portOper, sm->perPortGlobal->ptpPortEnabled, sm->perPortGlobal->asCapable, sm->perPortGlobal->asymmetryMeasurementMode);
        return MDSS_INITIALIZING;
    }
}

static void send_sync_action(MDSyncSendSM *sm, UScaledNs ts) {
    sm->rcvdMDSyncMDSS = 0;
    if (sm->txSyncPtr != NULL) {
        free(sm->txSyncPtr);
    }
    sm->txSyncPtr = setSyncTwoStep(sm);
    txSync(sm);
    sm->mdEntityGlobal->syncSequenceId++;
}

static MDSyncSendSMState send_sync_state_transition(MDSyncSendSM *sm, UScaledNs ts) {
    if (sm->rcvdMDTimestampReceiveMDSS) {
        return MDSS_SEND_FOLLOW_UP;
    } else {
        return MDSS_SEND_SYNC;
    }
}

static void send_follow_up_action(MDSyncSendSM *sm, UScaledNs ts) {
    sm->rcvdMDTimestampReceiveMDSS = 0;
    if (sm->txFollowUpPtr != NULL) {
        free(sm->txFollowUpPtr);
    }
    sm->txFollowUpPtr = setFollowUp(sm);
    txFollowUp(sm);
}

static MDSyncSendSMState send_follow_up_state_transition(MDSyncSendSM *sm, UScaledNs ts) {
    printf("MDSyncSendSM-send_follow_up_state_transition.\r\n");
    printf("  rcvdMDSyncMDSS: %d\r\n", sm->rcvdMDSyncMDSS);
    if (sm->rcvdMDSyncMDSS && sm->perPortGlobal->portOper && sm->perPortGlobal->ptpPortEnabled && sm->perPortGlobal->asCapable && !sm->perPortGlobal->asymmetryMeasurementMode) {
        return MDSS_SEND_SYNC;
    } else {
        return MDSS_SEND_FOLLOW_UP;
    }
}

void md_sync_send_sm_run(MDSyncSendSM *sm, UScaledNs ts) {
    bool state_change;
    sm->state = all_state_transition(sm);
    while (1) {
        state_change = (sm->last_state != sm->state);
        sm->last_state = sm->state;
        switch (sm->state) {
            case MDSS_INIT:
                sm->state = MDSS_INITIALIZING;
                break;
            case MDSS_INITIALIZING:
                if (state_change) initializing_action(sm, ts);
                sm->state = initializing_state_transition(sm, ts);
                break;
            case MDSS_SEND_SYNC:
                if (state_change) send_sync_action(sm, ts);
                sm->state = send_sync_state_transition(sm, ts);
                break;
            case MDSS_SEND_FOLLOW_UP:
                if (state_change) send_follow_up_action(sm, ts);
                sm->state = send_follow_up_state_transition(sm, ts);
                break;
        }
        if (sm->last_state == sm->state) break;
        else print_state_change(sm->perPortGlobal->thisPort, sm->last_state, sm->state);
    }
}

void init_md_sync_send_sm(MDSyncSendSM *sm, PerPTPInstanceGlobal *per_ptp_instance_global, PerPortGlobal *per_port_global, MDEntityGlobal *md_entity_global) {
    sm->perPTPInstanceGlobal = per_ptp_instance_global;
    sm->perPortGlobal = per_port_global;
    sm->mdEntityGlobal = md_entity_global;

    sm->rcvdMDSyncPtr = NULL;
    sm->rcvdMDTimestampReceivePtr = NULL;

    sm->txSyncPtr = NULL;
    sm->txFollowUpPtr = NULL;

    sm->state = MDSS_INIT;
    sm->last_state = MDSS_BEFORE_INIT;

    UScaledNs ts;
    ts.subns = 0;
    ts.nsec = 0;
    ts.nsec_msb = 0;

    md_sync_send_sm_run(sm, ts);
}

void md_sync_send_sm_recv_md_sync(MDSyncSendSM *sm, UScaledNs ts, MDSyncSend *md_sync_send_ptr) {
    if (sm->rcvdMDSyncPtr != NULL) {
        free(sm->rcvdMDSyncPtr);
    }
    sm->rcvdMDSyncMDSS = 1;
    sm->rcvdMDSyncPtr = malloc(sizeof(MDSyncSend));
    *sm->rcvdMDSyncPtr = *md_sync_send_ptr;

    md_sync_send_sm_run(sm, ts);
}

void md_sync_send_sm_txts(MDSyncSendSM *sm, UScaledNs ts, TSUTimestamp tsuTimestamp) {
    if (sm->state != MDSS_SEND_SYNC) {
        printf("Timestamp is not expectied by MDSyncSendSM.\r\n");
        return;
    }
    if (tsuTimestamp.sequenceID != sm->mdEntityGlobal->syncSequenceId - 1) {
        printf("Mismatched sequence ID for Sync timestamp. \r\n");
        return;
    }
    sm->rcvdMDTimestampReceiveMDSS = 1;
    if (sm->rcvdMDTimestampReceivePtr != NULL) {
        free(sm->rcvdMDTimestampReceivePtr);
    }
    sm->rcvdMDTimestampReceivePtr = malloc(sizeof(TSUTimestamp));
    *sm->rcvdMDTimestampReceivePtr = tsuTimestamp;
    sm->syncEventEgressTimestamp = tsuTimestamp.ts;
    md_sync_send_sm_run(sm, ts);
}
