/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-12 23:14:09
 * @FilePath: /linux_uio_app/tsu.c
 * @Description: 
 */
#include "tsu.h"


/**
 * @description: This function is used to init TSU module.
 * @param {void} *ptr uio base ptr.
 * @return {int} 0 by default.
 */
int tsu_init(void *ptr) {
	base_ptr_tsu = ptr;

	// Config MSGID. (This will determine which packet is going to be timestamped.)
	// 802.1AS 11.4.2.2
	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_RXQUE_STATUS)) = TSU_MASK_RXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_RXQUE_STATUS)) = TSU_MASK_RXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_RXQUE_STATUS)) = TSU_MASK_RXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_RXQUE_STATUS)) = TSU_MASK_RXMSGID;

	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_TXQUE_STATUS)) = TSU_MASK_TXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_TXQUE_STATUS)) = TSU_MASK_TXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_TXQUE_STATUS)) = TSU_MASK_TXMSGID;
	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_TXQUE_STATUS)) = TSU_MASK_TXMSGID;


	// Reset TSU
	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_RXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_RXCTRL)) = TSU_SET_RST;
	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_TXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_0_TSU_TXCTRL)) = TSU_SET_RST;

	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_RXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_RXCTRL)) = TSU_SET_RST;
	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_TXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_1_TSU_TXCTRL)) = TSU_SET_RST;

	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_RXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_RXCTRL)) = TSU_SET_RST;
	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_TXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_2_TSU_TXCTRL)) = TSU_SET_RST;

	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_RXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_RXCTRL)) = TSU_SET_RST;
	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_TXCTRL)) = TSU_SET_CTRL_0;
	*((unsigned *)(base_ptr_tsu + PORT_3_TSU_TXCTRL)) = TSU_SET_RST;

    return 0;
}

/**
 * @description: This function is used to get tx timestamp.
 * @param {uint16_t} portNumber port's number.
 * @param {TSUTimestamp} *tsuTimestamp tx timestamp ptr.
 * @return {int}
 */
int tsu_tx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp) {
	UINTPTR QUE_STATUS_ADDR, CTRL_ADDR;
	UINTPTR TSU_DATA_HH_ADDR, TSU_DATA_HL_ADDR, TSU_DATA_LH_ADDR, TSU_DATA_LL_ADDR;
	switch (portNumber)
	{
	case 1:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_0_TSU_TXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_0_TSU_TXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_0_TSU_TXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_0_TSU_TXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_0_TSU_TXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_0_TSU_TXQUE_DATA_LL;
		break;
	case 2:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_1_TSU_TXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_1_TSU_TXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_1_TSU_TXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_1_TSU_TXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_1_TSU_TXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_1_TSU_TXQUE_DATA_LL;
		break;
	case 3:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_2_TSU_TXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_2_TSU_TXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_2_TSU_TXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_2_TSU_TXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_2_TSU_TXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_2_TSU_TXQUE_DATA_LL;
		break;
	case 4:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_3_TSU_TXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_3_TSU_TXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_3_TSU_TXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_3_TSU_TXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_3_TSU_TXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_3_TSU_TXQUE_DATA_LL;
		break;
	default:
		printf("tsu tx get timestamp: Invalid portNumber.\r\n");
		return 0;
	}
	// printf("    Poll n_queue.\r\n");
	unsigned int rd_data;
	int n_queue;
    rd_data = *((unsigned*)(QUE_STATUS_ADDR));
    n_queue = rd_data & 0x00FFFFFF;
    // printf("    n_queue: %d\r\n", n_queue);
    if (n_queue == 0) {
        // printf("The tsu queue is empty. \r\n");
        return TSU_FETCH_FAILURE;
    }

	// printf("    Set TSU_GET_QUE.\r\n");
    *((unsigned*)(CTRL_ADDR)) = TSU_SET_CTRL_0;
    *((unsigned*)(CTRL_ADDR)) = TSU_GET_QUE;

	do {
		rd_data = *((unsigned*)(CTRL_ADDR));
	} while ((rd_data & TSU_GET_QUE) == 0x0);
	// printf("	Ready to fetch tsu data.\r\n");
	// TSU data format (128bit): 16bit 0 + 80 bit timestamp (48 bit seconds + 32 bit nano seconds) + 32 bit ptp_infor (4 bit msg id + 12 bit checksum + 16 bit sequence id).
	unsigned int ts_sec_h, ts_sec_l, ts_nsc, ptp_infor;
	ts_sec_h = *((unsigned*)(TSU_DATA_HH_ADDR));
	ts_sec_l = *((unsigned*)(TSU_DATA_HL_ADDR));
	ts_nsc = *((unsigned*)(TSU_DATA_LH_ADDR));
	ptp_infor = *((unsigned*)(TSU_DATA_LL_ADDR));
	// printf("    ts_sec_h: %08X\r\n", ts_sec_h);
	// printf("    ts_sec_l: %08X\r\n", ts_sec_l);
	// printf("    ts_nsc: %08X\r\n", ts_nsc);
	// printf("    ptp_infor: %08X\r\n", ptp_infor);
	int msg_id_ptp_infor = (ptp_infor >> 28) & 0xF;
	int checksum_ptp_infor = (ptp_infor & 0x0FFF0000) >> 16;
	int seq_id_ptp_infor = (ptp_infor & 0xFFFF);
    // again, not complete, but enough.
    tsuTimestamp->msgType = msg_id_ptp_infor & 0xF;
    tsuTimestamp->sequenceID = seq_id_ptp_infor & 0xFFFF;
    tsuTimestamp->ts.subns = 0;
    tsuTimestamp->ts.nsec = (uint64_t)ts_sec_l * 1000000000 + ts_nsc;
    tsuTimestamp->ts.nsec_msb = 0;
	return 1;
}

/**
 * @description: This function is used to get rx timestamp.
 * @param {uint16_t} portNumber port's number.
 * @param {TSUTimestamp} *tsuTimestamp rx timestamp ptr.
 * @return {int}
 */
int tsu_rx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp) {
	UINTPTR QUE_STATUS_ADDR, CTRL_ADDR;
	UINTPTR TSU_DATA_HH_ADDR, TSU_DATA_HL_ADDR, TSU_DATA_LH_ADDR, TSU_DATA_LL_ADDR;
	// printf("GrabTimeStamp.\r\n");
	switch (portNumber)
	{
	case 1:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_0_TSU_RXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_0_TSU_RXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_0_TSU_RXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_0_TSU_RXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_0_TSU_RXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_0_TSU_RXQUE_DATA_LL;
		// printf("    Received frame from port 0.\r\n");
		break;
	case 2:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_1_TSU_RXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_1_TSU_RXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_1_TSU_RXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_1_TSU_RXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_1_TSU_RXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_1_TSU_RXQUE_DATA_LL;
		// printf("    Received frame from port 1.\r\n");
		break;
	case 3:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_2_TSU_RXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_2_TSU_RXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_2_TSU_RXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_2_TSU_RXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_2_TSU_RXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_2_TSU_RXQUE_DATA_LL;
		// printf("    Received frame from port 2.\r\n");
		break;
	case 4:
		QUE_STATUS_ADDR = base_ptr_tsu + PORT_3_TSU_RXQUE_STATUS;
		CTRL_ADDR = base_ptr_tsu + PORT_3_TSU_RXCTRL;
		TSU_DATA_HH_ADDR = base_ptr_tsu + PORT_3_TSU_RXQUE_DATA_HH;
		TSU_DATA_HL_ADDR = base_ptr_tsu + PORT_3_TSU_RXQUE_DATA_HL;
		TSU_DATA_LH_ADDR = base_ptr_tsu + PORT_3_TSU_RXQUE_DATA_LH;
		TSU_DATA_LL_ADDR = base_ptr_tsu + PORT_3_TSU_RXQUE_DATA_LL;
		// printf("    Received frame from port 3.\r\n");
		break;
	default:
		printf("tsu rx timestamp: unknown port number.\r\n");
		return TSU_FETCH_FAILURE;
	}
	unsigned int rd_data;
	int n_queue;
	do {
		rd_data = *((unsigned*)(QUE_STATUS_ADDR));
		n_queue = rd_data & 0x00FFFFFF;
		// printf("    n_queue: %d\r\n", n_queue);
	} while (n_queue == 0);
	// printf("TSU RX Queue-%d n_queue: %d.\r\n", portNumber, n_queue);
    if (n_queue == 0) {
        // printf("The tsu rx queue of port %d is empty. \r\n", portNumber);
        return TSU_FETCH_FAILURE;
    }

	// printf("    Set TSU_GET_QUE.\r\n");
	*((unsigned*)(CTRL_ADDR)) = TSU_SET_CTRL_0;
	*((unsigned*)(CTRL_ADDR)) = TSU_GET_QUE;

	do {
		rd_data = *((unsigned*)(CTRL_ADDR));
	} while ((rd_data & TSU_GET_QUE) == 0x0);
	// printf("	Ready to fetch tsu data.\r\n");
	// TSU data format (128bit): 16bit 0 + 80 bit timestamp (48 bit seconds + 32 bit nano seconds) + 32 bit ptp_infor (4 bit msg id + 12 bit checksum + 16 bit sequence id).
	unsigned int ts_sec_h, ts_sec_l, ts_nsc, ptp_infor;
	ts_sec_h = *((unsigned*)(TSU_DATA_HH_ADDR));
	ts_sec_l = *((unsigned*)(TSU_DATA_HL_ADDR));
	ts_nsc = *((unsigned*)(TSU_DATA_LH_ADDR));
	ptp_infor = *((unsigned*)(TSU_DATA_LL_ADDR));
	// printf("    ts_sec_h: %08X\r\n", ts_sec_h);
	// printf("    ts_sec_l: %08X\r\n", ts_sec_l);
	// printf("    ts_nsc: %08X\r\n", ts_nsc);
	// printf("    ptp_infor: %08X\r\n", ptp_infor);
	int msg_id_ptp_infor = (ptp_infor >> 28) & 0xF;
	int checksum_ptp_infor = (ptp_infor & 0x0FFF0000) >> 16;
	int seq_id_ptp_infor = (ptp_infor & 0xFFFF);
    // again, not complete, but enough.
    tsuTimestamp->sequenceID = seq_id_ptp_infor & 0xFFFF;
    tsuTimestamp->ts.subns = 0;
    tsuTimestamp->ts.nsec = (uint64_t)ts_sec_l * 1000000000 + ts_nsc;
    tsuTimestamp->ts.nsec_msb = 0;
    tsuTimestamp->msgType = (ptp_infor >> 28) & 0x0F;
	return TSU_FETCH_SUCCESS;
}
