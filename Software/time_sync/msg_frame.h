#ifndef MSG_FRAME_H
#define MSG_FRAME_H

#include "../tsn_drivers/ptp_types.h"
#include "vscode.h"

// 2 + 4 + 4 = 10 bytes
typedef struct PTPFrameTimestamp {
	uint16_t seconds_msb;
	uint32_t seconds_lsb;
	uint32_t nanoseconds;
} __attribute__((packed)) PTPFrameTimestamp;

// 8.5.2 Port identity 10 bytes
typedef struct PTPFramePortIdentity {
	uint8_t clockIdentity[8]; // IEEE Std 1588-2019
	uint16_t portNumber; // 0: ClockMaster 1-0xFFFE: ports
} __attribute__((packed)) PTPFramePortIdentity;

// 11.4.2 Header
typedef struct PTPFrameHeader {
	uint8_t majorSdoId_messageType;
	uint8_t minorVersionPTP_versionPTP;
	uint16_t messageLength;
	uint8_t domainNumber;
	uint8_t minorSdoId;
	uint8_t flags[2];
	int64_t correctionField;
	uint8_t messageTypeSpecific[4];
	PTPFramePortIdentity sourcePortIdentity;
	uint16_t sequenceId;
	uint8_t controlField;
	int8_t logMessageInterval;
} __attribute__((packed)) PTPFrameHeader;

// 11.4.5 Pdelay_Req frame
typedef struct PTPFramePdelayReq {
	PTPFrameHeader head;
	uint8_t res0[10];
	uint8_t res1[10];
} __attribute__((packed)) PTPFramePdelayReq;

// 11.4.6 Pdelay_Resp frame
typedef struct PTPFramePdelayResp {
	PTPFrameHeader head;
	PTPFrameTimestamp requestReceiptTimestamp;
	PTPFramePortIdentity requestingPortIdentity;
} __attribute__((packed)) PTPFramePdelayResp;

typedef struct PTPFramePdelayRespFollowUp {
	PTPFrameHeader head;
	PTPFrameTimestamp responseOriginTimestamp;
	PTPFramePortIdentity requestingPortIdentity;
} __attribute__((packed)) PTPFramePdelayRespFollowUp;

typedef struct PTPFrameSync {
	PTPFrameHeader head;
	uint8_t res[10];
} __attribute__((packed)) PTPFrameSync;

typedef struct PTPFrameUScaledNs {
	uint16_t nsec_msb;
	uint64_t nsec;
	uint16_t subns;
} __attribute__((packed)) PTPFrameUScaledNs;

typedef PTPFrameUScaledNs PTPFrameScaledNs;

typedef struct PTPFrameFollowUpTLV {
	uint16_t tlvType;
	uint16_t lengthField;
	uint8_t organizationId[3];
	uint8_t organizationSubType[3];
	int32_t cumulativeScaledRateOffset;
	uint16_t gmTimeBaseIndicator;
	PTPFrameScaledNs lastGmPhaseChange;
	int32_t scaledLastGmFreqChange;
} __attribute__((packed)) PTPFrameFollowUpTLV;

typedef struct PTPFrameFollowUp {
	PTPFrameHeader head;
	PTPFrameTimestamp preciseOriginTimestamp;
	PTPFrameFollowUpTLV followUpInformationTLV;
} __attribute__((packed)) PTPFrameFollowUp;

uint16_t htons(uint16_t h);
uint16_t ntohs(uint16_t n);
uint32_t htonl(uint32_t h);
uint32_t ntohl(uint32_t n);
uint64_t htonll(uint64_t h);
uint64_t ntohll(uint64_t n);
void dump_buffer(uint8_t *buffer, int length);
void set_ptp_frame_header(PTPFrameHeader *frame_header, PTPMsgHeader *header);
void get_ptp_msg_header(PTPFrameHeader *frame_header, PTPMsgHeader *header);

#endif
