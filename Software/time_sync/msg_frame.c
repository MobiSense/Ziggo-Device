#include <stdio.h>
#include "msg_frame.h"

uint16_t htons(uint16_t h) {
    uint16_t n;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    n_ptr[0] = h_ptr[1];
    n_ptr[1] = h_ptr[0];
    return n;
}

uint16_t ntohs(uint16_t n) {
    uint16_t h;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    h_ptr[0] = n_ptr[1];
    h_ptr[1] = n_ptr[0];
    return h;
}

uint32_t htonl(uint32_t h) {
    uint32_t n;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    n_ptr[0] = h_ptr[3];
    n_ptr[1] = h_ptr[2];
    n_ptr[2] = h_ptr[1];
    n_ptr[3] = h_ptr[0];
    return n;    
}

uint32_t ntohl(uint32_t n) {
    uint32_t h;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    h_ptr[0] = n_ptr[3];
    h_ptr[1] = n_ptr[2];
    h_ptr[2] = n_ptr[1];
    h_ptr[3] = n_ptr[0];
    return h;
}

uint64_t htonll(uint64_t h) {
    uint64_t n;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    n_ptr[0] = h_ptr[7];
    n_ptr[1] = h_ptr[6];
    n_ptr[2] = h_ptr[5];
    n_ptr[3] = h_ptr[4];
    n_ptr[4] = h_ptr[3];
    n_ptr[5] = h_ptr[2];
    n_ptr[6] = h_ptr[1];
    n_ptr[7] = h_ptr[0];
    return n;
}

uint64_t ntohll(uint64_t n) {
    uint64_t h;
    uint8_t *h_ptr, *n_ptr;
    h_ptr = &h;
    n_ptr = &n;
    h_ptr[0] = n_ptr[7];
    h_ptr[1] = n_ptr[6];
    h_ptr[2] = n_ptr[5];
    h_ptr[3] = n_ptr[4];
    h_ptr[4] = n_ptr[3];
    h_ptr[5] = n_ptr[2];
    h_ptr[6] = n_ptr[1];
    h_ptr[7] = n_ptr[0];
    return h;
}

void dump_buffer(uint8_t *buffer, int length) {
    for (int i = 0; i < length; i++) {
        printf("%02X ", buffer[i]);
        if (i % 8 == 7) {
            printf("\r\n");
        }
    }
}

void set_ptp_frame_header(PTPFrameHeader *frame_header, PTPMsgHeader *header) {
	frame_header->majorSdoId_messageType = (header->majorSdoId << 4) | header->messageType;
	frame_header->minorVersionPTP_versionPTP = (header->minorVersionPTP << 4) |
		header->versionPTP;
	frame_header->messageLength = htons(header->messageLength);
	frame_header->domainNumber = header->domainNumber;
	frame_header->minorSdoId = header->minorSdoId;
	memcpy(frame_header->flags, header->flags, 2);
	frame_header->correctionField = htonll(header->correctionField);
	memcpy(frame_header->messageTypeSpecific, header->messageTypeSpecific, 4);
	memcpy(frame_header->sourcePortIdentity.clockIdentity, header->sourcePortIdentity.clockIdentity, 8);
	frame_header->sourcePortIdentity.portNumber = htons(header->sourcePortIdentity.portNumber);
	frame_header->sequenceId = htons(header->sequenceId);
	frame_header->controlField = header->controlField;
	frame_header->logMessageInterval = header->logMessageInterval;
}

void get_ptp_msg_header(PTPFrameHeader *frame_header, PTPMsgHeader *header) {
    header->majorSdoId = (frame_header->majorSdoId_messageType >> 4) & 0xF;
    header->messageType = frame_header->majorSdoId_messageType & 0xF;
    header->minorVersionPTP = (frame_header->minorVersionPTP_versionPTP >> 4) & 0xF;
    header->versionPTP = frame_header->minorVersionPTP_versionPTP & 0xF;
    header->messageLength = ntohs(frame_header->messageLength);
    header->domainNumber = frame_header->domainNumber;
    header->minorSdoId = frame_header->minorSdoId;
    memcpy(header->flags, frame_header->flags, 2);
    header->correctionField = ntohll(frame_header->correctionField);
    memcpy(header->messageTypeSpecific, frame_header->messageTypeSpecific, 4);
    memcpy(header->sourcePortIdentity.clockIdentity, frame_header->sourcePortIdentity.clockIdentity, 8);
    header->sourcePortIdentity.portNumber = ntohs(frame_header->sourcePortIdentity.portNumber);
    header->sequenceId = ntohs(frame_header->sequenceId);
    header->controlField = frame_header->controlField;
    header->logMessageInterval = header->logMessageInterval;
}