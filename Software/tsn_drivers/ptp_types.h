#ifndef PTP_TYPES_H
#define PTP_TYPES_H

#ifdef __cplusplus
extern "C" {
#endif


#include <stdint.h>
// #include "xil_types.h"

#define XST_SUCCESS 0
#define XST_FAILURE 1
#define DEFAULT_CLOCK_IDENTITY_H 0  // Higher 8 bytes
#define DEFAULT_CLOCK_IDENTITY_L 0  // Lower 8 bytes
#define DEFAULT_LOG_MESSAGE_INTERVAL 0
#define N_PORTS 4
#define ONE_SEC_NS 1000000000
#define MAXLENGTH \
    64  // a circular list length for neighborRateRatio computation

#define FLAG_MASK_LEAP61 0x01
#define FLAG_MASK_LEAP59 0x02
#define FLAG_MASK_UTC_OFFSET 0x04
#define FLAG_MASK_PTP_TIMESCALE 0x08
#define FLAG_MASK_TIME_TRACEABLE 0x10
#define FLAG_MASK_FREQ_TRACEABLE 0x20

typedef uintptr_t UINTPTR;

typedef uint8_t Nibble;
typedef uint8_t Octet;
typedef uint8_t Octet2[2];
typedef uint8_t Octet3[3];
typedef uint8_t Octet4[4];
typedef uint8_t Enumeration2;
typedef uint8_t Enumeration4;
typedef uint8_t Enumeration8;
typedef uint16_t Enumeration16;
typedef uint32_t Enumeration24;
typedef uint8_t UInteger4;

#ifndef __cplusplus
typedef uint8_t bool;
#endif

typedef enum {
    MASTER_PORT,
    SLAVE_PORT,
    PASSIVE_PORT,
    DISABLED_PORT,
} PortState;

typedef struct UScaledNs {
    uint16_t subns;
    uint64_t nsec;
    uint16_t nsec_msb;
} UScaledNs;

// typedef struct ScaledNs {
// 	uint16_t subns;
// 	uint64_t nsec;
// 	uint16_t nsec_msb;
// } ScaledNs;

typedef struct SystemIdentity {
    uint8_t priority1;
    uint8_t clockClass;
    uint8_t clockAccuracy;
    uint16_t offsetScaledLogVariance;
    uint8_t priority2;
    uint8_t clockIdentity[8];
} __attribute__((packed)) SystemIdentity;

typedef struct PriorityVector {
    SystemIdentity rootSystemIdentity;
    uint16_t stepsRemoved;
    uint8_t sourcePortClockIdentity[8];
    uint16_t sourcePortNumber;
    uint16_t portNumber;
} __attribute__((packed)) PriorityVector;

typedef struct PortIdentity {
    uint8_t clockIdentity[8];
    uint16_t portNumber;
} PortIdentity;

typedef UScaledNs ScaledNs;
typedef UScaledNs ExtendedTimestamp;

typedef struct GMPriority {
    PortIdentity sourcePortIdentity;
} GMPriority;

// Global variables
// 10.2.5 & 10.3.10
typedef struct PerPortGlobal {
    bool asCapable;
    bool asymmetryMeasurementMode;
    UScaledNs syncReceiptTimeoutTimeInterval;
    int8_t currentLogSyncInterval;
    UScaledNs syncInterval;
    double neighborRateRatio;
    UScaledNs meanLinkDelay;
    bool computeNeighborRateRatio;
    bool computeMeanLinkDelay;
    bool portOper;
    bool ptpPortEnabled;
    uint16_t thisPort;
    bool syncLocked;
    bool syncSlowDown;
    UScaledNs oldSyncInterval;
    uint16_t syncReceiptTimeout;

    UScaledNs announceInterval;
    int8_t currentLogAnnounceInterval;  // 0 for 1 second.
} PerPortGlobal;

typedef struct PerPTPInstanceGlobal {
    // 10.2.4
    bool BEGIN;
    UScaledNs clockMasterSyncInterval;
    int8_t clockMasterLogSyncInterval;
    // ExtendedTimestamp clockSlaveTime;
    ExtendedTimestamp syncReceiptTime;
    UScaledNs syncReceiptLocalTime;
    double clockSourceFreqOffset;
    ScaledNs clockSourcePhaseOffset;
    uint16_t clockSourceTimeBaseIndicator;
    uint16_t clockSourceTimeBaseIndicatorOld;
    bool instanceEnable;
    bool gmPresent;
    double gmRateRatio;
    uint16_t gmTimeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    double lastGmFreqChange;
    UScaledNs localTime;
    PortState selectedState[N_PORTS + 1];
    ExtendedTimestamp masterTime;
    uint8_t thisClock[8];
    int8_t parentLogSyncInterval;
    GMPriority gmPriority;
    UScaledNs syncReceiptTimeoutTime;

    // 10.3.9
    bool leap61;
    bool leap59;
    bool currentUtcOffsetValid;
    bool ptpTimescale;
    bool timeTraceable;
    bool frequencyTraceable;
    int16_t currentUtcOffset;
    uint8_t timeSource;
    PriorityVector gmPriorityVector;
    uint16_t gmStepsRemoved;
    uint16_t nPathTrace;
    uint8_t pathTrace[8][8];  // at most 8 hops

    bool externalPortConfigurationEnabled;

} PerPTPInstanceGlobal;

// 11.2.13
typedef struct MDEntityGlobal {
    bool isMeasuringDelay;
    bool asCapableAcrossDomains;
    uint8_t allowedLostResponses;
    UScaledNs pdelayReqInterval;
    UScaledNs meanLinkDelayThresh;
    uint8_t allowedFaults;

    uint16_t syncSequenceId;
} MDEntityGlobal;

// 11.4 Message formats
typedef enum {
    NO_FRAME = -1,
    SYNC = 0,
    PDELAY_REQ = 2,
    PDELAY_RESP = 3,
    FOLLOW_UP = 8,
    PDELAY_RESP_FOLLOW_UP = 10,
    ANNOUNCE = 11,
} PTPMsgType;

typedef struct PTPMsgTimestamp {
    uint16_t seconds_msb;
    uint32_t seconds_lsb;
    uint32_t nanoseconds;
} PTPMsgTimestamp;

typedef struct PTPMsgHeader {
    Nibble majorSdoId;
    Enumeration4 messageType;
    UInteger4 minorVersionPTP;
    UInteger4 versionPTP;
    uint16_t messageLength;
    uint8_t domainNumber;
    uint8_t minorSdoId;
    Octet2 flags;
    int64_t correctionField;
    Octet4 messageTypeSpecific;
    PortIdentity sourcePortIdentity;
    uint16_t sequenceId;
    uint8_t controlField;
    int8_t logMessageInterval;
} PTPMsgHeader;

typedef struct PTPMsgPdelayReq {
    PTPMsgHeader head;
} PTPMsgPdelayReq;

typedef struct PTPMsgPdelayResp {
    PTPMsgHeader head;
    PTPMsgTimestamp requestReceiptTimestamp;
    PortIdentity requestingPortIdentity;
} PTPMsgPdelayResp;

typedef struct PTPMsgPdelayRespFollowUp {
    PTPMsgHeader head;
    PTPMsgTimestamp responseOriginTimestamp;
    PortIdentity requestingPortIdentity;
} PTPMsgPdelayRespFollowUp;

typedef struct PTPMsgSync {
    PTPMsgHeader head;
} PTPMsgSync;

typedef struct PTPMsgFollowUpTLV {
    uint16_t tlvType;
    uint16_t lengthField;
    uint8_t organizationId[3];
    uint8_t organizationSubType[3];
    int32_t cumulativeScaledRateOffset;
    uint16_t gmTimeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    int32_t scaledLastGmFreqChange;
} PTPMsgFollowUpTLV;

typedef struct PTPMsgFollowUp {
    PTPMsgHeader head;
    PTPMsgTimestamp preciseOriginTimestamp;
    PTPMsgFollowUpTLV followUpInformationTLV;
} PTPMsgFollowUp;

typedef struct ClockQuality {
    uint8_t clockClass;
    Enumeration8 clockAccuracy;
    uint16_t offsetScaledLogVariance;
} ClockQuality;

typedef struct PTPMsgPathTraceTLV {
    uint16_t tlvType;      // The value of the tlvType field is 0x8
    uint16_t lengthField;  // in bytes, not including tlvType and LengthField
    uint8_t pathSequence[8][8];  // consider at most 8 hops
} PTPMsgPathTraceTLV;

typedef struct PTPMsgAnnounce {
    PTPMsgHeader head;
    int16_t currentUtcOffset;
    uint8_t grandmasterPriority1;
    ClockQuality grandmasterClockQuality;
    uint8_t grandmasterPriority2;
    uint8_t grandmasterIdentity[8];
    uint16_t stepsRemoved;
    uint8_t timeSource;
    PTPMsgPathTraceTLV pathTraceTLV;
} PTPMsgAnnounce;

typedef struct TSUTimestamp {
    UScaledNs ts;
    uint16_t sequenceID;
    uint8_t msgType;
} TSUTimestamp;

typedef struct PortSyncSync {
    uint8_t domainNumber;
    uint16_t localPortNumber;
    UScaledNs syncReceiptTimeoutTime;
    ScaledNs followUpCorrectionField;
    PortIdentity sourcePortIdentity;
    int8_t logMessageInterval;
    PTPMsgTimestamp preciseOriginTimestamp;
    UScaledNs upstreamTxTime;
    double rateRatio;
    uint16_t gmTimeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    double lastGmFreqChange;
} PortSyncSync;

typedef struct ClockSourceTimeInvoke {
    uint8_t domainNumber;
    ExtendedTimestamp sourceTime;
    uint16_t timeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    double lastGmFreqChange;
} ClockSourceTimeInvoke;

typedef struct MDSyncReceive {
    uint8_t domainNumber;
    ScaledNs followUpCorrectionField;
    PortIdentity sourcePortIdentity;
    int8_t logMessageInterval;
    PTPMsgTimestamp preciseOriginTimestamp;
    UScaledNs upstreamTxTime;
    double rateRatio;
    uint16_t gmTimeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    double lastGmFreqChange;
} MDSyncReceive;

typedef struct MDSyncSend {
    uint8_t domainNumber;
    ScaledNs followUpCorrectionField;
    PortIdentity sourcePortIdentity;
    int8_t logMessageInterval;
    PTPMsgTimestamp preciseOriginTimestamp;
    UScaledNs upstreamTxTime;
    double rateRatio;
    uint16_t gmTimeBaseIndicator;
    ScaledNs lastGmPhaseChange;
    double lastGmFreqChange;
} MDSyncSend;

void ptp_msg_header_template(PTPMsgHeader *head, PTPMsgType msgtype,
                             uint16_t len, PortIdentity *portId, uint16_t seqid,
                             int8_t logMessageInterval, int64_t correction);
void ptp_msg_ann_header_template(PTPMsgHeader *head, PTPMsgType msgtype,
                                 uint16_t len, PortIdentity *portId,
                                 uint16_t seqid, int8_t logMessageInterval,
                                 int64_t correction,
                                 PerPTPInstanceGlobal *perPTPInstanceGlobal);
UScaledNs uscaledns_subtract(UScaledNs t1, UScaledNs t2);
UScaledNs uscaledns_add(UScaledNs t1, UScaledNs t2);
UScaledNs uscaledns_mul(UScaledNs t1, UScaledNs t2);
UScaledNs uscaledns_mul_double(UScaledNs t1, double r);
double uscaledns_div(UScaledNs t1, UScaledNs t2);
void print_uscaledns(UScaledNs t);
UScaledNs uscaledns_divide_by_2(UScaledNs t);
int uscaledns_compare(UScaledNs t1, UScaledNs t2);
uint64_t uint64_uscaledns(UScaledNs t);
UScaledNs uscaledns_uint64(uint64_t t);
UScaledNs uscaledns_double(double r);
int portIdentityEqual(PortIdentity pi1, PortIdentity pi2);
UScaledNs uscaledns_ptpmsgtimestamp(PTPMsgTimestamp ptpmsgts);
PTPMsgTimestamp ptpmsgtimestamp_uscaledns(UScaledNs usns);
PTPMsgTimestamp ptpmsgtimestamp_extendedtimestamp(ExtendedTimestamp ts);
void set_default_clock_identity(uint8_t *clock_identity);
void print_path_trace(uint8_t *pathTrace);

#ifdef __cplusplus
}
#endif
#endif
