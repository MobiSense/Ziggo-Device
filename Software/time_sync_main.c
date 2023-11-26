/******************************************************************************
 * Copyright (C) 2010 - 2020 Xilinx, Inc.  All rights reserved.
 * SPDX-License-Identifier: MIT
 ******************************************************************************/
/*
 * Author: Horace He.
 * Date:   2021.11.22
 * Linux TSN Device APP
 * 	Time Syncronization + Packet Generation
 */

/***************************** Include Files *********************************/

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "config.h"
#include "dma_proxy/buffer_queue.h"
#include "dma_proxy/dma-proxy.h"
#include "pkt_gen_control/pkt_gen.h"
#include "time_sync/eth_frame.h"
#include "time_sync/msg_frame.h"
#include "time_sync/state_machines.h"
#include "tsn_drivers/rtc.h"
#include "tsn_drivers/tsu.h"
#include "tsn_drivers/uio.h"

#include "log/log.h"

#if defined(XPAR_UARTNS550_0_BASEADDR)
#include "xuartns550_l.h" /* to use uartns550 */
#endif

/******************** Constant Definitions **********************************/

#define MEM_BASE_ADDR 0x01000000

#define TX_BUFFER_BASE (MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE (MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH (MEM_BASE_ADDR + 0x004FFFFF)

#define MAX_PKT_LEN 1600
#define FRAME_PTP_OFFSET 46
#define FRAME_PTP_MSG_TYPE_OFFSET FRAME_PTP_OFFSET
#define FRAME_PTP_PORT_ID_OFFSET FRAME_PTP_OFFSET + 20
#define FRAME_PTP_SEQ_ID_OFFSET FRAME_PTP_OFFSET + 30

#define TEST_START_VALUE 0xC

#define NUMBER_OF_TRANSFERS 10

// Dst Ports
#define DST_PORT_0 0x02
#define DST_PORT_1 0x08
#define DST_PORT_2 0x20
#define DST_PORT_3 0x80

#define CPU_HEADER_LENGTH 32

// Mac address Type
#define MAC_ADDR_TYPE_PTP 0

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

/************************** Function Prototypes ******************************/

// Start developing 802.1AS
int TimeSyncMainLoop(buffer_queue *queue);

/************************** Variable Definitions *****************************/

/*
 * This function is the Main function to test RTC read and write.
 */

#define TIME_SYNC_BASE_ADDR 0x43C00000
// define RTC address values
#define RTC_CTRL 0x00000000
#define RTC_NULL_0x04 0x00000004
#define RTC_NULL_0x08 0x00000008
#define RTC_NULL_0x0C 0x0000000C
#define RTC_TIME_SEC_H 0x00000010
#define RTC_TIME_SEC_L 0x00000014
#define RTC_TIME_NSC_H 0x00000018
#define RTC_TIME_NSC_L 0x0000001C
#define RTC_PERIOD_H 0x00000020
#define RTC_PERIOD_L 0x00000024
#define RTC_ADJPER_H 0x00000028
#define RTC_ADJPER_L 0x0000002C
#define RTC_ADJNUM 0x00000030
#define RTC_NULL_0x34 0x00000034
#define RTC_NULL_0x38 0x00000038
#define RTC_NULL_0x3C 0x0000003C
// define RTC control values
#define RTC_SET_CTRL_0 0x00
#define RTC_GET_TIME 0x01
#define RTC_SET_ADJ 0x02
#define RTC_SET_PERIOD 0x04
#define RTC_SET_TIME 0x08
#define RTC_SET_RESET 0x10
// define RTC data values
#define RTC_SET_PERIOD_H 0x16  // 16ns for double speed clock
#define RTC_SET_PERIOD_L 0x0
// define RTC constant
#define RTC_ACCMOD_H 0x3B9ACA00  // 1,000,000,000 for 30bit
#define RTC_ACCMOD_L 0x0         // 256 for 8bit

// define TSU address values Port 0
#define PORT_0_TSU_RXCTRL 0x00000040
#define PORT_0_TSU_RXQUE_STATUS 0x00000044
#define PORT_0_TSU_NULL_0x48 0x00000048
#define PORT_0_TSU_NULL_0x4C 0x0000004C
#define PORT_0_TSU_RXQUE_DATA_HH 0x00000050
#define PORT_0_TSU_RXQUE_DATA_HL 0x00000054
#define PORT_0_TSU_RXQUE_DATA_LH 0x00000058
#define PORT_0_TSU_RXQUE_DATA_LL 0x0000005C
#define PORT_0_TSU_TXCTRL 0x00000060
#define PORT_0_TSU_TXQUE_STATUS 0x00000064
#define PORT_0_TSU_NULL_0x68 0x00000068
#define PORT_0_TSU_NULL_0x6C 0x0000006C
#define PORT_0_TSU_TXQUE_DATA_HH 0x00000070
#define PORT_0_TSU_TXQUE_DATA_HL 0x00000074
#define PORT_0_TSU_TXQUE_DATA_LH 0x00000078
#define PORT_0_TSU_TXQUE_DATA_LL 0x0000007C

// define TSU address values Port 1
#define PORT_1_TSU_RXCTRL 0x00000080
#define PORT_1_TSU_RXQUE_STATUS 0x00000084
#define PORT_1_TSU_NULL_0x48 0x00000088
#define PORT_1_TSU_NULL_0x4C 0x0000008C
#define PORT_1_TSU_RXQUE_DATA_HH 0x00000090
#define PORT_1_TSU_RXQUE_DATA_HL 0x00000094
#define PORT_1_TSU_RXQUE_DATA_LH 0x00000098
#define PORT_1_TSU_RXQUE_DATA_LL 0x0000009C
#define PORT_1_TSU_TXCTRL 0x000000A0
#define PORT_1_TSU_TXQUE_STATUS 0x000000A4
#define PORT_1_TSU_NULL_0x68 0x000000A8
#define PORT_1_TSU_NULL_0x6C 0x000000AC
#define PORT_1_TSU_TXQUE_DATA_HH 0x000000B0
#define PORT_1_TSU_TXQUE_DATA_HL 0x000000B4
#define PORT_1_TSU_TXQUE_DATA_LH 0x000000B8
#define PORT_1_TSU_TXQUE_DATA_LL 0x000000BC

// define TSU address values Port 2
#define PORT_2_TSU_RXCTRL 0x000000C0
#define PORT_2_TSU_RXQUE_STATUS 0x000000C4
#define PORT_2_TSU_NULL_0x48 0x000000C8
#define PORT_2_TSU_NULL_0x4C 0x000000CC
#define PORT_2_TSU_RXQUE_DATA_HH 0x000000D0
#define PORT_2_TSU_RXQUE_DATA_HL 0x000000D4
#define PORT_2_TSU_RXQUE_DATA_LH 0x000000D8
#define PORT_2_TSU_RXQUE_DATA_LL 0x000000DC
#define PORT_2_TSU_TXCTRL 0x000000E0
#define PORT_2_TSU_TXQUE_STATUS 0x000000E4
#define PORT_2_TSU_NULL_0x68 0x000000E8
#define PORT_2_TSU_NULL_0x6C 0x000000EC
#define PORT_2_TSU_TXQUE_DATA_HH 0x000000F0
#define PORT_2_TSU_TXQUE_DATA_HL 0x000000F4
#define PORT_2_TSU_TXQUE_DATA_LH 0x000000F8
#define PORT_2_TSU_TXQUE_DATA_LL 0x000000FC

// define TSU address values Port 3
#define PORT_3_TSU_RXCTRL 0x00000100
#define PORT_3_TSU_RXQUE_STATUS 0x00000104
#define PORT_3_TSU_NULL_0x48 0x00000108
#define PORT_3_TSU_NULL_0x4C 0x0000010C
#define PORT_3_TSU_RXQUE_DATA_HH 0x00000110
#define PORT_3_TSU_RXQUE_DATA_HL 0x00000114
#define PORT_3_TSU_RXQUE_DATA_LH 0x00000118
#define PORT_3_TSU_RXQUE_DATA_LL 0x0000011C
#define PORT_3_TSU_TXCTRL 0x00000120
#define PORT_3_TSU_TXQUE_STATUS 0x00000124
#define PORT_3_TSU_NULL_0x68 0x00000128
#define PORT_3_TSU_NULL_0x6C 0x0000012C
#define PORT_3_TSU_TXQUE_DATA_HH 0x00000130
#define PORT_3_TSU_TXQUE_DATA_HL 0x00000134
#define PORT_3_TSU_TXQUE_DATA_LH 0x00000138
#define PORT_3_TSU_TXQUE_DATA_LL 0x0000013C

// define TSU control values
#define TSU_SET_CTRL_0 0x00
#define TSU_GET_QUE 0x01
#define TSU_SET_RST 0x02
// define TSU data values
#define TSU_MASK_RXMSGID 0x0D000000  // 8'b0000_1101
#define TSU_MASK_TXMSGID 0x0D000000  // 8'b0000_1101
// // Addresses
// #define TIME_SYNC_BASE_ADDR 0x43C00000
// #define TIME_SYNC_RTC_CTRL_OFFSET 0x00000000

// // Values
// #define TIME_SYNC_RTC_SET_CTRL_0 0x00000000
// #define TIME_SYNC_RTC_SET_RESET  0x
//

// DMA RX related multi-thread packet FIFO
pthread_t tid;
buffer_queue *queue;

/*
 * This is the first attempt to construct the main loop function for time_sync
 * after we have finished PdelayReqSM.
 */
int TimeSyncMainLoop(buffer_queue *queue) {
    void *ptr;
    ptr = uio_init("/dev/uio1");
    rtc_init(ptr);
    tsu_init(ptr);
    axi_dma_init();

    // Global variables
    PerPTPInstanceGlobal per_ptp_instance_global;
    PerPortGlobal per_port_global[4];
    MDEntityGlobal md_entity_global[4];

    // Init global variables
    per_ptp_instance_global.BEGIN = 0;
    per_ptp_instance_global.instanceEnable = 1;
    per_ptp_instance_global.gmPresent = 1;
    set_default_clock_identity(per_ptp_instance_global.thisClock);
    // 0: local clock port;
    // if 0 is slave port, then local clock is used as master
    // Only one slave port, others must be master or disabled port

    per_ptp_instance_global.selectedState[0] = MASTER_PORT;
    per_ptp_instance_global.selectedState[1] = SLAVE_PORT;
    per_ptp_instance_global.selectedState[2] = DISABLED_PORT;
    per_ptp_instance_global.selectedState[3] = DISABLED_PORT;
    per_ptp_instance_global.selectedState[4] = DISABLED_PORT;

    per_ptp_instance_global.clockSourceTimeBaseIndicatorOld = 0;
    per_ptp_instance_global.clockSourceTimeBaseIndicator = 0;
    per_ptp_instance_global.clockSourcePhaseOffset.subns = 0;
    per_ptp_instance_global.clockSourcePhaseOffset.nsec = 0;
    per_ptp_instance_global.clockSourcePhaseOffset.nsec_msb = 0;
    per_ptp_instance_global.clockSourceFreqOffset = 0.0;
    per_ptp_instance_global.clockMasterSyncInterval.subns = 0;
    per_ptp_instance_global.clockMasterSyncInterval.nsec = ONE_SEC_NS;
    per_ptp_instance_global.clockMasterSyncInterval.nsec_msb = 0;

    for (int i = 0; i < 4; i++) {
        per_port_global[i].asCapable = 1;
        per_port_global[i].syncReceiptTimeout = 10;
        per_port_global[i].syncReceiptTimeoutTimeInterval.subns = 0;
        per_port_global[i].syncReceiptTimeoutTimeInterval.nsec = 1000000000;
        per_port_global[i].syncReceiptTimeoutTimeInterval.nsec_msb = 0;

        per_port_global[i].syncInterval.subns = 0;
        per_port_global[i].syncInterval.nsec_msb = 0;
        per_port_global[i].syncInterval.nsec = ONE_SEC_NS;
        per_port_global[i].oldSyncInterval.subns = 0;
        per_port_global[i].oldSyncInterval.nsec_msb = 0;
        per_port_global[i].oldSyncInterval.nsec = ONE_SEC_NS;

        per_port_global[i].asymmetryMeasurementMode = 0;
        per_port_global[i].computeMeanLinkDelay = 1;
        per_port_global[i].computeNeighborRateRatio = 1;
        per_port_global[i].meanLinkDelay.nsec_msb = 0;
        per_port_global[i].meanLinkDelay.nsec = 0;
        per_port_global[i].meanLinkDelay.subns = 0;
        per_port_global[i].neighborRateRatio = 1.0;
        per_port_global[i].portOper = 0;
        per_port_global[i].ptpPortEnabled = 0;
        per_port_global[i].thisPort = i + 1;
    }

    per_port_global[0].portOper = 1;
    per_port_global[0].ptpPortEnabled = 1;

    for (int i = 0; i < 4; i++) {
        md_entity_global[i].allowedFaults = 255;
        md_entity_global[i].allowedLostResponses = 255;
        md_entity_global[i].asCapableAcrossDomains = 0;
        md_entity_global[i].isMeasuringDelay = 1;
        md_entity_global[i].meanLinkDelayThresh.nsec_msb = 0xFFFF;
        md_entity_global[i].meanLinkDelayThresh.nsec = 0;
        md_entity_global[i].meanLinkDelayThresh.subns = 0;
        md_entity_global[i].pdelayReqInterval.nsec_msb = 0;
        md_entity_global[i].pdelayReqInterval.nsec = 1000000000;
        md_entity_global[i].pdelayReqInterval.subns = 0;
    }

    // State machines
    ClockMasterSyncReceiveSM clock_master_sync_receive_sm;
    ClockMasterSyncSendSM clock_master_sync_send_sm;
    SiteSyncSyncSM site_sync_sync_sm;
    ClockSlaveSyncSM clock_slave_sync_sm;
    MDPdelayReqSM md_pdelay_req_sms[N_PORTS];
    MDPdelayRespSM md_pdelay_resp_sms[N_PORTS];
    PortSyncSyncReceiveSM port_sync_sync_receive_sms[N_PORTS];
    PortSyncSyncSendSM port_sync_sync_send_sms[N_PORTS];
    MDSyncSendSM md_sync_send_sms[N_PORTS];
    MDSyncReceiveSM md_sync_receive_sms[N_PORTS];

    // Init state machines
    init_clock_master_sync_receive_sm(&clock_master_sync_receive_sm,
                                      &per_ptp_instance_global);
    init_clock_master_sync_send_sm(&clock_master_sync_send_sm,
                                   &per_ptp_instance_global,
                                   &site_sync_sync_sm);
    init_site_sync_sync_sm(&site_sync_sync_sm, &per_ptp_instance_global,
                           &clock_slave_sync_sm, port_sync_sync_send_sms);
    init_clock_slave_sync_sm(&clock_slave_sync_sm, &per_ptp_instance_global,
                             per_port_global);
    for (int i = 0; i < 4; i++) {
        init_port_sync_sync_receive_sm(&port_sync_sync_receive_sms[i],
                                       &per_ptp_instance_global,
                                       &per_port_global[i], &site_sync_sync_sm);
        init_port_sync_sync_send_sm(&port_sync_sync_send_sms[i],
                                    &per_ptp_instance_global,
                                    &per_port_global[i], &md_sync_send_sms[i]);
        init_md_pdelay_req_sm(&md_pdelay_req_sms[i], &per_port_global[i],
                              &per_ptp_instance_global, &md_entity_global[i]);
        init_md_pdelay_resp_sm(&md_pdelay_resp_sms[i], &per_port_global[i],
                               &per_ptp_instance_global, &md_entity_global[i]);
        init_md_sync_send_sm(&md_sync_send_sms[i], &per_ptp_instance_global,
                             &per_port_global[i], &md_entity_global[i]);
        init_md_sync_receive_sm(&md_sync_receive_sms[i],
                                &per_ptp_instance_global, &per_port_global[i],
                                &port_sync_sync_receive_sms[i]);
    }

    log_info("Init state machines done.");

    UScaledNs current_ts;
    uint8_t *recv_msg_ptr;
    TSUTimestamp *tsu_ts_ptr;
    PTPMsgType recv_status;
    uint16_t port_number;
    ClockSourceTimeInvoke *source_time_req_ptr;

    while (1) {
        // Update master time.
        source_time_req_ptr = malloc(sizeof(ClockSourceTimeInvoke));
        source_time_req_ptr->domainNumber = 0;
        source_time_req_ptr->lastGmFreqChange = 0.0;
        source_time_req_ptr->lastGmPhaseChange.subns = 0;
        source_time_req_ptr->lastGmPhaseChange.nsec = 0;
        source_time_req_ptr->lastGmPhaseChange.nsec_msb = 0;
        source_time_req_ptr->timeBaseIndicator = 0;
        current_ts = get_current_timestamp();
        source_time_req_ptr->sourceTime = (ExtendedTimestamp)current_ts;
        clock_master_sync_receive_sm_recv_source_time(
            &clock_master_sync_receive_sm, source_time_req_ptr, current_ts);

        //		printf("Update master time done.\r\n");

        // Check for timeout events
        clock_master_sync_send_sm_run(&clock_master_sync_send_sm, current_ts);
        for (int i = 0; i < 4; i++) {
            md_pdelay_req_sm_run(&md_pdelay_req_sms[i], current_ts);
            md_sync_receive_sm_run(&md_sync_receive_sms[i], current_ts);
        }
        //		printf("Timeout check done.\r\n");

        // Check for frame receive buffer

        // TODO: change this to read from a message queue
        recv_status =
            recv_ptp_frame(&recv_msg_ptr, &tsu_ts_ptr, &port_number, queue);
        if (recv_status != NO_FRAME) {
            if (md_pdelay_resp_sms[0].rcvdPdelayReqPtr != NULL) {
                printf("Check PDelayReq Seq ID: %d. \r\n",
                       md_pdelay_resp_sms[0].rcvdPdelayReqPtr->head.sequenceId);
            } else {
                // printf("md_pdelay_resp_sms-0-rcvdPdelayReqPtr is NULL.\r\n");
            }
        }
        switch (recv_status) {
            case NO_FRAME:
                break;
            case PDELAY_REQ:
                md_pdelay_resp_sm_recv_req(&md_pdelay_resp_sms[port_number - 1],
                                           current_ts, tsu_ts_ptr,
                                           recv_msg_ptr);
                break;
            case PDELAY_RESP:
                // printf("recv pdelay resp msg from port %d.\r\n", port_number);
                md_pdelay_req_sm_recv_resp(&md_pdelay_req_sms[port_number - 1],
                                           current_ts, tsu_ts_ptr,
                                           recv_msg_ptr);
                // printf("recvd\r\n");
                break;
            case PDELAY_RESP_FOLLOW_UP:
                // printf("recv pdelay resp follow up msg from port %d.\r\n",
                    //    port_number);
                md_pdelay_req_sm_recv_resp_follow_up(
                    &md_pdelay_req_sms[port_number - 1], current_ts,
                    recv_msg_ptr);
                break;
            case SYNC:
                // printf("main loop recv sync from port %d. \r\n", port_number);
                md_sync_receive_sm_recv_sync(
                    &md_sync_receive_sms[port_number - 1], current_ts,
                    tsu_ts_ptr, recv_msg_ptr);
                break;
            case FOLLOW_UP:
                md_sync_receive_sm_recv_follow_up(
                    &md_sync_receive_sms[port_number - 1], current_ts,
                    recv_msg_ptr);
                break;
        }

        // Check for tx tsu timestamp
        //		printf("Check TX Timestamp.\r\n");
        int tx_ts_status;
        TSUTimestamp tsu_tx_ts;
        for (uint16_t port_i = 1; port_i < 5; port_i++) {
            tx_ts_status = tsu_tx_get_timestamp(port_i, &tsu_tx_ts);
            if (tx_ts_status == 0) {
                continue;
            } else {
                // printf("tsu_tx_ts.msgType: %d\r\n", tsu_tx_ts.msgType);
                switch (tsu_tx_ts.msgType) {
                    case PDELAY_REQ:
                        md_pdelay_req_sm_txts(&md_pdelay_req_sms[port_i - 1],
                                              current_ts, tsu_tx_ts);
                        break;
                    case PDELAY_RESP:
                        md_pdelay_resp_sm_txts(&md_pdelay_resp_sms[port_i - 1],
                                               current_ts, tsu_tx_ts);
                        break;
                    case SYNC:
                        md_sync_send_sm_txts(&md_sync_send_sms[port_i - 1],
                                             current_ts, tsu_tx_ts);
                        break;
                    default:
                        printf(
                            "Unknown TX TSU MSG TYPE when check tx timestamp. "
                            "\r\n");
                        break;
                }
            }
        }
    }
}

/*****************************************************************************/
/**
 * The entry point for this example. It invokes the example function,
 * and reports the execution status.
 *
 * @param	None.
 *
 * @return
 *		- EXIT_SUCCESS if example finishes successfully
 *		- EXIT_FAILURE if example fails.
 *
 * @note		None.
 *
 ******************************************************************************/
int main(int argc,char * argv[]) {
    int opt = 0;
    int log_level = LOG_TRACE;
    while ((opt = getopt(argc, argv, "hl:")) != -1) {
        switch (opt) {
            case 'h':
                printf("Usage: ./time_sync -l <w/i/t>\n");
                printf("-l: log_level, w(warn), i(info), t(trace)\n");
                return 0;
            case 'l':
                if (strcmp(optarg, "w") == 0) {
                    log_level = LOG_WARN;
                } else if (strcmp(optarg, "i") == 0) {
                    log_level = LOG_INFO;
                } else if (strcmp(optarg, "t") == 0) {
                    log_level = LOG_TRACE;
                } else {
                    printf("Unknown Log level. Usage: ./time_sync -l <w/i/t>\n");
                    return 0;
                }
                break;
            default:
                printf("error opterr: %d\n", opterr);
                return 0;
        }
    }
    log_set_level(log_level);
    printf("Log level is [LOF_TRACE] by default.\n");
    printf("Usage: ./time_sync -l <w/i/t>\n");
    printf("-l: log_level, w(warn), i(info), t(trace)\n");

    reset_PL_by_GPIO("960");

    // 	pkt_gen_test();

    log_info("--- Entering main() ---");

    // printf("\r\n--- Setting up packet generation configruation --- \r\n");

    log_info("--- Launching DMA receving thread --- ");

    // init DMA
    axi_dma_init();
    // init RX buffer queue
    queue = malloc(sizeof(buffer_queue));
    init_queue(queue);
    // init buffer queue mutex
    if (pthread_mutex_init(&buf_queue_lock, NULL) != 0) {
        log_error ("Fail to initialize buffer queue mutex. ");
    }
    // launch rx thread
    pthread_create(&tid, NULL, DMA_rx_thread, (void *)queue);

    log_info ("--- Start time syncronization. ---");
    // start time syncronization
    TimeSyncMainLoop(queue);
    log_info ("--- Finish time syncronization. ---");

    pthread_join(tid, NULL);

    log_info("--- Exiting main() --- ");

    return EXIT_SUCCESS;
}
