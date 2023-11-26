#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>
#include <signal.h>
#include <sched.h>
#include <time.h>
#include <errno.h>
#include <sys/param.h>
#include <pthread.h>


#include "eth_frame.h"
#include <string.h>
#include "../tsn_drivers/ptp_types.h"
#include "msg_frame.h"
#include "../tsn_drivers/tsu.h"
#include "../dma_proxy/dma-proxy.h"
#include "../dma_proxy/buffer_queue.h"
#include "../pkt_gen_control/pkt_gen.h"
#include "../log/log.h"

// #define MEM_BASE_ADDR		0x01000000
// #define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
// #define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)

#define MAX_PKT_LEN		    1600
#define PAY_LOAD_OFFSET     14

#define TX_DEFAULT_DST_MAC_ADDR_0 0x01
#define TX_DEFAULT_DST_MAC_ADDR_1 0x80
#define TX_DEFAULT_DST_MAC_ADDR_2 0xC2
#define TX_DEFAULT_DST_MAC_ADDR_3 0x00
#define TX_DEFAULT_DST_MAC_ADDR_4 0x00
#define TX_DEFAULT_DST_MAC_ADDR_5 0x0E

#define TX_DEFAULT_SRC_MAC_ADDR_0 0x00
#define TX_DEFAULT_SRC_MAC_ADDR_1 0x0a
#define TX_DEFAULT_SRC_MAC_ADDR_2 0x35 // Xilinx MAC address
#define TX_DEFAULT_SRC_MAC_ADDR_3 0xCC
#define TX_DEFAULT_SRC_MAC_ADDR_4 0xF9
#define TX_DEFAULT_SRC_MAC_ADDR_5 0x73

#define TX_DEFAULT_ETH_TYPE_0 0X88
#define TX_DEFAULT_ETH_TYPE_1 0XF7

#define DMA_DEV_ID XPAR_AXIDMA_0_DEVICE_ID
#define CACHE_LINE_LENGTH 32
#define EMAC_ALIGN __attribute__ ((__aligned__(CACHE_LINE_LENGTH)))

// Global variables
// XAxiDma AxiDma;
// uint8_t TX_BUFFER_BASE[MAX_PKT_LEN] EMAC_ALIGN;
// uint8_t RX_BUFFER_BASE[MAX_PKT_LEN] EMAC_ALIGN;

uint8_t TxBufferPtr[MAX_PKT_LEN];
uint8_t RxBufferPtr[MAX_PKT_LEN];

static uint16_t ParseSrcPort(uint8_t *RxBufferPtr)
{
	// uint8_t *RxPacket; 
	// uint16_t SrcPort;
	// RxPacket = RxBufferPtr;
	// if (RxPacket[2] == 0x01) {
	// 	SrcPort = 1;
	// } else if (RxPacket[2] == 0x04) {
	// 	SrcPort = 2;
	// } else if (RxPacket[2] == 0x10) {
	// 	SrcPort = 3;
	// } else if (RxPacket[2] == 0x40) {
	// 	SrcPort = 4;
	// } else {
	// 	printf("Error: Unknow Src Port!!");
	// 	SrcPort = 0xFFFF;
	// }
	// return SrcPort;

    /* only enable port 1 for tsn device project now */
    return 1;
}

static const char* get_msg_type_name(PTPMsgType msgType) {
    switch (msgType)
    {
    case PDELAY_REQ:
        return "PDELAY_REQ";
    case PDELAY_RESP:
        return "PDELAY_RESP";
    case PDELAY_RESP_FOLLOW_UP:
        return "PDELAY_RESP_FOLLOW_UP";
    case SYNC:
        return "SYNC";
    case FOLLOW_UP:
        return "FOLLOW_UP";
    default:
        return "NOT KNOWN";
    }
}

void send_ptp_frame(uint8_t *buffer, int length, uint16_t portNumber, char* msg_type, uint16_t seq_id) {    
    log_debug("=====> <%s> [Seq: %d] Send ptp frame to [PORT %d]", msg_type, seq_id, portNumber);

    /* Only enable port 1, so no specification required.*/
    // switch (portNumber)
    // {
    // case 1:
    //     TxBufferPtr[CPU_HEADER_SRC_PORT] = DST_PORT_1;
    //     break;
    // case 2:
    //     TxBufferPtr[CPU_HEADER_SRC_PORT] = DST_PORT_2;
    //     break;
    // case 3:
    //     TxBufferPtr[CPU_HEADER_SRC_PORT] = DST_PORT_3;
    //     break;
    // case 4:
    //     TxBufferPtr[CPU_HEADER_SRC_PORT] = DST_PORT_4;
    //     break;
    // default:
    //     break;
    // }

    TxBufferPtr[0] = TX_DEFAULT_DST_MAC_ADDR_0;
    TxBufferPtr[1] = TX_DEFAULT_DST_MAC_ADDR_1;
    TxBufferPtr[2] = TX_DEFAULT_DST_MAC_ADDR_2;
    TxBufferPtr[3] = TX_DEFAULT_DST_MAC_ADDR_3;
    TxBufferPtr[4] = TX_DEFAULT_DST_MAC_ADDR_4;
    TxBufferPtr[5] = TX_DEFAULT_DST_MAC_ADDR_5;
    TxBufferPtr[6] = TX_DEFAULT_SRC_MAC_ADDR_0;
    TxBufferPtr[7] = TX_DEFAULT_SRC_MAC_ADDR_1;
    TxBufferPtr[8] = TX_DEFAULT_SRC_MAC_ADDR_2;
    TxBufferPtr[9] = TX_DEFAULT_SRC_MAC_ADDR_3;
    TxBufferPtr[10] = TX_DEFAULT_SRC_MAC_ADDR_4;
    TxBufferPtr[11] = TX_DEFAULT_SRC_MAC_ADDR_5;
    TxBufferPtr[12] = TX_DEFAULT_ETH_TYPE_0;
    TxBufferPtr[13] = TX_DEFAULT_ETH_TYPE_1;
    
    memcpy(TxBufferPtr + PAY_LOAD_OFFSET, buffer, length);

	DMA_send(TxBufferPtr, length+PAY_LOAD_OFFSET);
}



PTPMsgType recv_ptp_frame(uint8_t **buffer_ptr_ptr, TSUTimestamp **ts_ptr_ptr, uint16_t *port_number_ptr,
        buffer_queue *queue) {
    RecvStatus Status;
    PTPMsgType returnType;
    

    // TODO:  改成查找 buffer queue
    int length;
    pthread_mutex_lock(&buf_queue_lock);
    // printf ("eth_frame.c: Entering critical region for buffer_queue.\r\n");
    if (queue->size > 0) {
        Status = RECV_FRAME; // receive a packet
        pop_queue (queue, RxBufferPtr, &length);
    } else {
        Status = RECV_NOTHING; // no available packet
    }
    pthread_mutex_unlock(&buf_queue_lock);
    // printf ("eth_frame.c: Leaving critical region for buffer_queue.\r\n");


    if (Status == RECV_FRAME) {
        // We received a frame.
        PTPMsgHeader header;
        TSUTimestamp *ts_ptr;
        get_ptp_msg_header(RxBufferPtr + PAY_LOAD_OFFSET, &header);

        // if (!is_ptp_frame(RxBufferPtr)) {
        //     header.messageType = NO_FRAME;
        //     if (is_critical_frame(RxBufferPtr)) {
        //         print_critical_frame(RxBufferPtr);
        //     }
        // }

        uint16_t portNumber = ParseSrcPort(RxBufferPtr);
        *port_number_ptr = portNumber;
        switch (header.messageType) {
            case PDELAY_REQ:
                log_debug("<===== <PDELAY_REQ> Receive ptp frame from [PORT: %d], [Seq ID: %d].", portNumber, header.sequenceId);
                // printf("ETH Frame Port %d: recv PDELAY_REQ, Seq ID: %d. \r\n", portNumber, header.sequenceId);
                returnType = PDELAY_REQ;
                PTPMsgPdelayReq* pdelayReqPtr;
                pdelayReqPtr = malloc(sizeof(PTPMsgPdelayReq));
                ts_ptr = malloc(sizeof(TSUTimestamp));
                pdelayReqPtr->head = header;
                PTPFramePdelayReq *pdelayReqFramePtr = RxBufferPtr + PAY_LOAD_OFFSET;
                *buffer_ptr_ptr = pdelayReqPtr;
                *ts_ptr_ptr = ts_ptr;
                tsu_rx_get_timestamp(portNumber, ts_ptr);
                while (ts_ptr->msgType != PDELAY_REQ || pdelayReqPtr->head.sequenceId != ts_ptr->sequenceID) {
                    log_warn("TSU Timestamp MSG TYPE or Seq ID not match. Expect PDELAY_REQ, get %s. Expect Seq ID: %d, get %d.", get_msg_type_name(ts_ptr->msgType), pdelayReqPtr->head.sequenceId, ts_ptr->sequenceID);
                    // returnType = NO_FRAME;
                    // free(pdelayReqPtr);
                    // free(ts_ptr);
                    tsu_rx_get_timestamp(portNumber, ts_ptr);

                }
                break;
            case PDELAY_RESP:
                log_debug("<===== <PDELAY_RESP> Receive ptp frame from [PORT: %d].", portNumber);
                // printf("ETH Frame Port %d: recv PDELAY_RESP. \r\n", portNumber);
                returnType = PDELAY_RESP;
                PTPMsgPdelayResp* pdelayRespPtr;
                pdelayRespPtr = malloc(sizeof(PTPMsgPdelayResp));
                ts_ptr = malloc(sizeof(TSUTimestamp));
                pdelayRespPtr->head = header;
                PTPFramePdelayResp* pdelayRespFramePtr = RxBufferPtr + PAY_LOAD_OFFSET;
                // printf("Frame portNumber: %04X\r\n", pdelayRespFramePtr->requestingPortIdentity.portNumber);
                pdelayRespPtr->requestingPortIdentity.portNumber = ntohs(pdelayRespFramePtr->requestingPortIdentity.portNumber);
                memcpy(pdelayRespPtr->requestingPortIdentity.clockIdentity, pdelayRespFramePtr->requestingPortIdentity.clockIdentity, 8);
                pdelayRespPtr->requestReceiptTimestamp.nanoseconds = ntohl(pdelayRespFramePtr->requestReceiptTimestamp.nanoseconds);
                pdelayRespPtr->requestReceiptTimestamp.seconds_lsb = ntohl(pdelayRespFramePtr->requestReceiptTimestamp.seconds_lsb);
                pdelayRespPtr->requestReceiptTimestamp.seconds_msb = ntohs(pdelayRespFramePtr->requestReceiptTimestamp.seconds_msb);
                *buffer_ptr_ptr = pdelayRespPtr;
                *ts_ptr_ptr = ts_ptr;
                tsu_rx_get_timestamp(portNumber, ts_ptr);
                while (ts_ptr->msgType != PDELAY_RESP || pdelayRespPtr->head.sequenceId != ts_ptr->sequenceID) {
                    log_warn("TSU Timestamp MSG TYPE or Seq ID not match. Expect PDELAY_RESP, get %s. Expect Seq ID: %d, get %d.", get_msg_type_name(ts_ptr->msgType), pdelayRespPtr->head.sequenceId, ts_ptr->sequenceID);
                    // returnType = NO_FRAME;
                    // free(pdelayRespPtr);
                    // free(ts_ptr);
                    tsu_rx_get_timestamp(portNumber, ts_ptr);
                }
                break;
            case PDELAY_RESP_FOLLOW_UP:
                // printf("ETH Frame Port %d: recv PDELAY_RESP_FOLLOW_UP. \r\n", portNumber);
                returnType = PDELAY_RESP_FOLLOW_UP;
                PTPMsgPdelayRespFollowUp* pdelayRespFollowupPtr;
                pdelayRespFollowupPtr = malloc(sizeof(PTPMsgPdelayRespFollowUp));
                pdelayRespFollowupPtr->head = header;
                PTPFramePdelayRespFollowUp* pdelayRespFollowupFramePtr = RxBufferPtr + PAY_LOAD_OFFSET;
                pdelayRespFollowupPtr->requestingPortIdentity.portNumber = pdelayRespFollowupFramePtr->requestingPortIdentity.portNumber;
                memcpy(pdelayRespFollowupPtr->requestingPortIdentity.clockIdentity, pdelayRespFollowupFramePtr->requestingPortIdentity.clockIdentity, 8);
                pdelayRespFollowupPtr->responseOriginTimestamp.nanoseconds = ntohl(pdelayRespFollowupFramePtr->responseOriginTimestamp.nanoseconds);
                pdelayRespFollowupPtr->responseOriginTimestamp.seconds_lsb = ntohl(pdelayRespFollowupFramePtr->responseOriginTimestamp.seconds_lsb);
                pdelayRespFollowupPtr->responseOriginTimestamp.seconds_msb = ntohs(pdelayRespFollowupFramePtr->responseOriginTimestamp.seconds_msb);

                // print ts in PdelayRespFollowUp, [seconds_lsb + nanoseconds] are converted to [nanoseconds]
                UScaledNs tx_ts = uscaledns_ptpmsgtimestamp(pdelayRespFollowupPtr->responseOriginTimestamp);
                uint32_t *ns_h, *ns_l;
                ns_l = &tx_ts.nsec;
                ns_h = ns_l + 1;
                log_debug("<===== <PDELAY_RESP_FOLLOW_UP> Receive ptp frame from [PORT: %d] [TS: %08X %08X].", portNumber, *ns_h, *ns_l);
                *buffer_ptr_ptr = pdelayRespFollowupPtr;
                break;
            case SYNC:
                log_debug("<===== <SYNC> Receive ptp frame from [PORT: %d], [Seq ID: %d].", portNumber, header.sequenceId);
                // printf("ETH Frame Port %d: recv SYNC. \r\n", portNumber);
                returnType = SYNC;
                PTPMsgSync *syncPtr = malloc(sizeof(PTPMsgSync));
                syncPtr->head = header;
                // PTPFrameSync *syncFramePtr = RxBufferPtr + PAY_LOAD_OFFSET;
                *buffer_ptr_ptr = syncPtr;
                ts_ptr = malloc(sizeof(TSUTimestamp));
                tsu_rx_get_timestamp(portNumber, ts_ptr);
                *ts_ptr_ptr = ts_ptr;
                while (ts_ptr->msgType != SYNC || syncPtr->head.sequenceId != ts_ptr->sequenceID) {
                    log_warn("TSU Timestamp MSG TYPE or Seq ID not match. Expect SYNC, get %s. Expect Seq ID: %d, get %d.", get_msg_type_name(ts_ptr->msgType), syncPtr->head.sequenceId, ts_ptr->sequenceID);
                    // returnType = NO_FRAME;
                    // free(syncPtr);
                    // free(ts_ptr);
                    tsu_rx_get_timestamp(portNumber, ts_ptr);
                }
                break;
            case FOLLOW_UP:
                log_debug("<===== <FOLLOW_UP> Receive ptp frame from [PORT: %d].", portNumber);
                // printf("ETH Frame Port %d: recv FOLLOW_UP. \r\n", portNumber);
                returnType = FOLLOW_UP;
                PTPMsgFollowUp *followUpPtr = malloc(sizeof(PTPMsgFollowUp));
                followUpPtr->head = header;
                PTPFrameFollowUp *followUpFramePtr = RxBufferPtr + PAY_LOAD_OFFSET;
                followUpPtr->preciseOriginTimestamp.nanoseconds = ntohl(followUpFramePtr->preciseOriginTimestamp.nanoseconds);
                followUpPtr->preciseOriginTimestamp.seconds_lsb = ntohl(followUpFramePtr->preciseOriginTimestamp.seconds_lsb);
                followUpPtr->preciseOriginTimestamp.seconds_msb = ntohs(followUpFramePtr->preciseOriginTimestamp.seconds_msb);
                followUpPtr->followUpInformationTLV.tlvType = ntohs(followUpFramePtr->followUpInformationTLV.tlvType);
                followUpPtr->followUpInformationTLV.lengthField = ntohs(followUpFramePtr->followUpInformationTLV.lengthField);
                memcpy(followUpPtr->followUpInformationTLV.organizationId, followUpFramePtr->followUpInformationTLV.organizationId, 3);
                memcpy(followUpPtr->followUpInformationTLV.organizationSubType, followUpFramePtr->followUpInformationTLV.organizationSubType, 3);
                followUpPtr->followUpInformationTLV.cumulativeScaledRateOffset = ntohl(followUpFramePtr->followUpInformationTLV.cumulativeScaledRateOffset);
                followUpPtr->followUpInformationTLV.gmTimeBaseIndicator = ntohs(followUpFramePtr->followUpInformationTLV.gmTimeBaseIndicator);
                followUpPtr->followUpInformationTLV.lastGmPhaseChange.nsec_msb = ntohs(followUpFramePtr->followUpInformationTLV.lastGmPhaseChange.nsec_msb);
                followUpPtr->followUpInformationTLV.lastGmPhaseChange.nsec = ntohll(followUpFramePtr->followUpInformationTLV.lastGmPhaseChange.nsec);
                followUpPtr->followUpInformationTLV.lastGmPhaseChange.subns = ntohs(followUpFramePtr->followUpInformationTLV.lastGmPhaseChange.subns);
                followUpPtr->followUpInformationTLV.scaledLastGmFreqChange = ntohl(followUpFramePtr->followUpInformationTLV.scaledLastGmFreqChange);
                *buffer_ptr_ptr = followUpPtr;
                break;
            default:
                returnType = NO_FRAME;
                break;
        }
        
        return returnType;
    } else {
        return NO_FRAME;
    }

}
