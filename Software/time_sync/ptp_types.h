#ifndef PTP_TYPES_H
#define PTP_TYPES_H

#include "vscode.h"
#include <stdint.h>
// #include "xil_types.h"

#define XST_SUCCESS 0
#define XST_FAILURE 1
#define DEFAULT_CLOCK_IDENTITY_H 0 // Higher 8 bytes
#define DEFAULT_CLOCK_IDENTITY_L 0 // Lower 8 bytes
#define DEFAULT_LOG_MESSAGE_INTERVAL 0
#define N_PORTS 4
#define ONE_SEC_NS 1000000000
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

typedef uint8_t bool;

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
// 10.2.5
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
} PerPortGlobal;

// 10.2.4
typedef struct PerPTPInstanceGlobal {
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

void ptp_msg_header_template(PTPMsgHeader *head, PTPMsgType msgtype, uint16_t len,
			PortIdentity *portId, uint16_t seqid, int8_t logMessageInterval, int64_t correction);
UScaledNs uscaledns_subtract(UScaledNs t1, UScaledNs t2);
UScaledNs uscaledns_add(UScaledNs t1, UScaledNs t2);
void print_uscaledns(UScaledNs t);
UScaledNs uscaledns_divide_by_2(UScaledNs t);
int uscaledns_compare(UScaledNs t1, UScaledNs t2);
uint64_t uint64_uscaledns(UScaledNs t);
UScaledNs uscaledns_uint64(uint64_t t);
int portIdentityEqual(PortIdentity pi1, PortIdentity pi2);
UScaledNs uscaledns_ptpmsgtimestamp(PTPMsgTimestamp ptpmsgts);
PTPMsgTimestamp ptpmsgtimestamp_uscaledns(UScaledNs usns);
PTPMsgTimestamp ptpmsgtimestamp_extendedtimestamp(ExtendedTimestamp ts);
void set_default_clock_identity(uint8_t *clock_identity);

#endif
