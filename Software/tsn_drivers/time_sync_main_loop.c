/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-12 23:14:58
 * @FilePath: /linux_uio_app/time_sync_main_loop.c
 * @Description: 
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#include "rtc.h"
#include "tsu.h"
#include "gcl.h"
#include "tagger.h"
#include "uio.h"
#include "gpio_reset.h"


#define MEM_BASE_ADDR		0x01000000
#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#define MAX_PKT_LEN		    1600

#define CPU_HEADER_LENGTH 32
#define FRAME_PTP_OFFSET    46
#define FRAME_PTP_MSG_TYPE_OFFSET FRAME_PTP_OFFSET
#define FRAME_PTP_PORT_ID_OFFSET FRAME_PTP_OFFSET + 20
#define FRAME_PTP_SEQ_ID_OFFSET FRAME_PTP_OFFSET + 30

// define TSU address values Port 0
#define PORT_0_TSU_RXCTRL        0x00000040
#define PORT_0_TSU_RXQUE_STATUS  0x00000044
#define PORT_0_TSU_NULL_0x48     0x00000048
#define PORT_0_TSU_NULL_0x4C     0x0000004C
#define PORT_0_TSU_RXQUE_DATA_HH 0x00000050
#define PORT_0_TSU_RXQUE_DATA_HL 0x00000054
#define PORT_0_TSU_RXQUE_DATA_LH 0x00000058
#define PORT_0_TSU_RXQUE_DATA_LL 0x0000005C
#define PORT_0_TSU_TXCTRL        0x00000060
#define PORT_0_TSU_TXQUE_STATUS  0x00000064
#define PORT_0_TSU_NULL_0x68     0x00000068
#define PORT_0_TSU_NULL_0x6C     0x0000006C
#define PORT_0_TSU_TXQUE_DATA_HH 0x00000070
#define PORT_0_TSU_TXQUE_DATA_HL 0x00000074
#define PORT_0_TSU_TXQUE_DATA_LH 0x00000078
#define PORT_0_TSU_TXQUE_DATA_LL 0x0000007C

// define TSU address values Port 1
#define PORT_1_TSU_RXCTRL        0x00000080
#define PORT_1_TSU_RXQUE_STATUS  0x00000084
#define PORT_1_TSU_NULL_0x48     0x00000088
#define PORT_1_TSU_NULL_0x4C     0x0000008C
#define PORT_1_TSU_RXQUE_DATA_HH 0x00000090
#define PORT_1_TSU_RXQUE_DATA_HL 0x00000094
#define PORT_1_TSU_RXQUE_DATA_LH 0x00000098
#define PORT_1_TSU_RXQUE_DATA_LL 0x0000009C
#define PORT_1_TSU_TXCTRL        0x000000A0
#define PORT_1_TSU_TXQUE_STATUS  0x000000A4
#define PORT_1_TSU_NULL_0x68     0x000000A8
#define PORT_1_TSU_NULL_0x6C     0x000000AC
#define PORT_1_TSU_TXQUE_DATA_HH 0x000000B0
#define PORT_1_TSU_TXQUE_DATA_HL 0x000000B4
#define PORT_1_TSU_TXQUE_DATA_LH 0x000000B8
#define PORT_1_TSU_TXQUE_DATA_LL 0x000000BC

// define TSU address values Port 2
#define PORT_2_TSU_RXCTRL        0x000000C0
#define PORT_2_TSU_RXQUE_STATUS  0x000000C4
#define PORT_2_TSU_NULL_0x48     0x000000C8
#define PORT_2_TSU_NULL_0x4C     0x000000CC
#define PORT_2_TSU_RXQUE_DATA_HH 0x000000D0
#define PORT_2_TSU_RXQUE_DATA_HL 0x000000D4
#define PORT_2_TSU_RXQUE_DATA_LH 0x000000D8
#define PORT_2_TSU_RXQUE_DATA_LL 0x000000DC
#define PORT_2_TSU_TXCTRL        0x000000E0
#define PORT_2_TSU_TXQUE_STATUS  0x000000E4
#define PORT_2_TSU_NULL_0x68     0x000000E8
#define PORT_2_TSU_NULL_0x6C     0x000000EC
#define PORT_2_TSU_TXQUE_DATA_HH 0x000000F0
#define PORT_2_TSU_TXQUE_DATA_HL 0x000000F4
#define PORT_2_TSU_TXQUE_DATA_LH 0x000000F8
#define PORT_2_TSU_TXQUE_DATA_LL 0x000000FC

// define TSU address values Port 3
#define PORT_3_TSU_RXCTRL        0x00000100
#define PORT_3_TSU_RXQUE_STATUS  0x00000104
#define PORT_3_TSU_NULL_0x48     0x00000108
#define PORT_3_TSU_NULL_0x4C     0x0000010C
#define PORT_3_TSU_RXQUE_DATA_HH 0x00000110
#define PORT_3_TSU_RXQUE_DATA_HL 0x00000114
#define PORT_3_TSU_RXQUE_DATA_LH 0x00000118
#define PORT_3_TSU_RXQUE_DATA_LL 0x0000011C
#define PORT_3_TSU_TXCTRL        0x00000120
#define PORT_3_TSU_TXQUE_STATUS  0x00000124
#define PORT_3_TSU_NULL_0x68     0x00000128
#define PORT_3_TSU_NULL_0x6C     0x0000012C
#define PORT_3_TSU_TXQUE_DATA_HH 0x00000130
#define PORT_3_TSU_TXQUE_DATA_HL 0x00000134
#define PORT_3_TSU_TXQUE_DATA_LH 0x00000138
#define PORT_3_TSU_TXQUE_DATA_LL 0x0000013C

// define TSU control values
#define TSU_SET_CTRL_0  0x00
#define TSU_GET_QUE   0x01
#define TSU_SET_RST   0x02

// Mac address Type
#define MAC_ADDR_TYPE_PTP 0

// define RTC address values
#define RTC_CTRL       0x00000000
#define RTC_NULL_0x04  0x00000004
#define RTC_NULL_0x08  0x00000008
#define RTC_NULL_0x0C  0x0000000C
#define RTC_TIME_SEC_H 0x00000010
#define RTC_TIME_SEC_L 0x00000014
#define RTC_TIME_NSC_H 0x00000018
#define RTC_TIME_NSC_L 0x0000001C
#define RTC_PERIOD_H   0x00000020
#define RTC_PERIOD_L   0x00000024
#define RTC_ADJPER_H   0x00000028
#define RTC_ADJPER_L   0x0000002C
#define RTC_ADJNUM     0x00000030
#define RTC_NULL_0x34  0x00000034
#define RTC_NULL_0x38  0x00000038
#define RTC_NULL_0x3C  0x0000003C
// define RTC control values
#define RTC_SET_CTRL_0 0x00
#define RTC_GET_TIME   0x01
#define RTC_SET_ADJ    0x02
#define RTC_SET_PERIOD 0x04
#define RTC_SET_TIME   0x08
#define RTC_SET_RESET  0x10
// define RTC data values
#define RTC_SET_PERIOD_H 0x8     // 16ns for double speed clock
#define RTC_SET_PERIOD_L 0x0
// define RTC constant
#define RTC_ACCMOD_H 0x3B9ACA00  // 1,000,000,000 for 30bit
#define RTC_ACCMOD_L 0x0         // 256 for 8bit


// define GCL address values Port 0
#define PORT_0_GCL_CTRL 0x00000150
// define GCL address values Port 1
#define PORT_1_GCL_CTRL 0x00000194
// define GCL address values Port 2
#define PORT_2_GCL_CTRL 0x000001D8
// define GCL address values Port 3
#define PORT_3_GCL_CTRL 0x0000021C



// define GCL control values
#define GCL_SET_CTRL_0 0x00
#define GCL_SET_RST    0x02

#define RTC_MAP_SIZE 65536

#define DMA_DEV_ID	0

void RTCTest(){
	void *ptr;
	ptr = uio_init("/dev/uio0");
	rtc_init(ptr);
	printf("\r\n--- RTCTest --- \r\n");
	while(1) {
		get_current_timestamp();
		sleep(1);
	}
	return;
	// Print times for 10 seconds.
	unsigned int data_o;
	while (1) {
		*((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
		*((unsigned *)(base_ptr + RTC_CTRL)) = RTC_GET_TIME;
		do {
			data_o = *((unsigned *)(base_ptr + RTC_CTRL));
			// xil_printf("Check RTC CTRL: %08x \r\n", data_o);
		} while ((data_o & RTC_GET_TIME) == 0x0);

		data_o = *((unsigned *)(base_ptr + RTC_TIME_SEC_H));
		printf("time: %08x \n", data_o);
		data_o =  *((unsigned *)(base_ptr + RTC_TIME_SEC_L));
		printf("%08x seconds \n", data_o);

		if (data_o >= 10) {
			break;
		}
		data_o = *((unsigned *)(base_ptr + RTC_TIME_NSC_H));
		printf("%08x nano seconds \n", data_o);
		data_o = *((unsigned *)(base_ptr + RTC_TIME_NSC_L));
		printf("%08x fractional nano seconds\r\n", data_o);
	}
	// This set the time of RTC to a specified value.
	*((unsigned*)(base_ptr + RTC_TIME_SEC_H)) = 0x1;
	*((unsigned*)(base_ptr + RTC_TIME_SEC_L)) = 0x0;
	*((unsigned*)(base_ptr + RTC_TIME_NSC_H)) = 0x1;
	*((unsigned*)(base_ptr + RTC_TIME_NSC_L)) = 0x0;
	*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
	*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_TIME;

	while (1) {
		*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
		*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_GET_TIME;
		do {
		// for (int i = 0; i < 10; i++) {
			data_o = *((unsigned*)(base_ptr + RTC_CTRL));
			// xil_printf("Check RTC CTRL: %08x \r\n", data_o);
		} while ((data_o & RTC_GET_TIME) == 0x0);
		// }

		data_o = *((unsigned*)(base_ptr + RTC_TIME_SEC_H));
		printf("time: %08x ", data_o);
		data_o = *((unsigned*)(base_ptr + RTC_TIME_SEC_L));
		printf("%08x seconds ", data_o);
		sleep(1);
		if (data_o >= 10) {
			break;
		}

		data_o = *((unsigned*)(base_ptr + RTC_TIME_NSC_H));
		printf("%08x nano seconds ", data_o);
		data_o = *((unsigned*)(base_ptr + RTC_TIME_NSC_L));
		printf("%08x fractional nano seconds\r\n", data_o);
	}

	// Set the period to 16ns
	*((unsigned*)(base_ptr + RTC_PERIOD_H)) = RTC_SET_PERIOD_H;
	*((unsigned*)(base_ptr + RTC_PERIOD_L)) = RTC_SET_PERIOD_L;
	*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
	*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_PERIOD;

	while (1) {
		*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
		*((unsigned*)(base_ptr + RTC_CTRL)) = RTC_GET_TIME;
		do {
			data_o = *((unsigned*)(base_ptr + RTC_CTRL));
			// xil_printf("Check RTC CTRL: %08x \r\n", data_o);
		} while ((data_o & RTC_GET_TIME) == 0x0);

		data_o = *((unsigned*)(base_ptr + RTC_TIME_SEC_H));
		printf("time: %08x ", data_o);
		data_o = *((unsigned*)(base_ptr + RTC_TIME_SEC_L));
		printf("%08x seconds ", data_o);
		sleep(1);
		if (data_o >= 30) {
			break;
		}

		data_o = *((unsigned*)(base_ptr + RTC_TIME_NSC_H));
		printf("%08x nano seconds ", data_o);
		data_o = *((unsigned*)(base_ptr + RTC_TIME_NSC_L));
		printf("%08x fractional nano seconds\r\n", data_o);
	}
}

void RTCOFFsetTest() {
	void *ptr;
	ptr = uio_init("/dev/uio0");
	rtc_init(ptr);
	UScaledNs offset;
	offset.nsec_msb = 0;
	offset.nsec = 0;
	offset.subns = 0;
	set_rtc_sync_offset(RTC_OFFSET_ADD, &offset);
	UScaledNs local, sync;
	do {
		get_current_local_sync_ts(&local, &sync);
		printf("Local Time:");
		print_uscaledns(local);
		printf("Sync Time:");
		print_uscaledns(sync);
		sleep(1);
	} while (local.nsec <= (uint64_t) 15 * ONE_SEC_NS);

	offset.nsec_msb = 0;
	offset.nsec = (uint64_t) 256 * ONE_SEC_NS - 1;
	offset.subns = 0;
	set_rtc_sync_offset(RTC_OFFSET_ADD, &offset);
	printf("Offset 1\r\n");
	do {
		get_current_local_sync_ts(&local, &sync);
		printf("Local Time:");
		print_uscaledns(local);
		printf("Sync Time:");
		print_uscaledns(sync);
		sleep(1);
	} while (local.nsec <= (uint64_t) 30 * ONE_SEC_NS);
	offset.nsec = (uint64_t) 16 * ONE_SEC_NS - 1;
	set_rtc_sync_offset(RTC_OFFSET_SUB, &offset);
	printf("Offset 2\r\n");
	do {
		get_current_local_sync_ts(&local, &sync);
		printf("Local Time:");
		print_uscaledns(local);
		printf("Sync Time:");
		print_uscaledns(sync);
		sleep(1);
	} while (local.nsec <= (uint64_t) 45 * ONE_SEC_NS);
}

static int ParseSrcPort(void)
{
	uint8_t *RxPacket;
	int SrcPort;
	RxPacket = (uint8_t *) RX_BUFFER_BASE;
	if (RxPacket[2] == 0x01) {
		SrcPort = 0;
	} else if (RxPacket[2] == 0x04) {
		SrcPort = 1;
	} else if (RxPacket[2] == 0x10) {
		SrcPort = 2;
	} else if (RxPacket[2] == 0x40) {
		SrcPort = 3;
	} else {
		printf("Error: Unknow Src Port!!");
		SrcPort = -1;
	}
	return SrcPort;
}

static int ParseETHData(void)
{
	uint8_t *RxPacket;
	int IndexBase = 32;
	int Index = 0;
	int SrcPort;

	RxPacket = (uint8_t *) RX_BUFFER_BASE;

	/* Invalidate the DestBuffer before receiving the data, in case the
	 * Data Cache is enabled
	 */
//	Xil_DCacheInvalidateRange((UINTPTR)RxPacket, MAX_PKT_LEN);
	SrcPort = ParseSrcPort();
	if (SrcPort == -1) {
		return XST_FAILURE;
	}
	printf("SrcPort: %d\r\n", SrcPort);

	// Print dst mac addr
	printf("The Dst MAC addr: ");
	for (; Index < 6; Index++) {
		printf("%02X ", (unsigned int)RxPacket[IndexBase + Index]);
	}
	printf("\r\n");

	// Print src mac addr
	printf("The Src MAC addr: ");
	for (; Index < 12; Index++) {
		printf("%02X ", (unsigned int)RxPacket[IndexBase + Index]);
	}
	printf("\r\n");

	// Print EtherType
	printf("The EtherType: ");
	for (; Index < 14; Index++) {
		printf("%02X", (unsigned int)RxPacket[IndexBase + Index]);
	}

	// int ether_type =
	printf("\r\n");

	return XST_SUCCESS;
}
/*
 * This tool function calculates checksum.
 */
static int CalcCheckSum(uint8_t *buffer, int offset, int length)
{
	int check_sum = 0;
	for (int i = 0; i < length; i++) {
		check_sum += buffer[offset + i];
	}
	return check_sum & 0xFFF;
}

/*
 * This function grab the timestamp related to the received PTP packet.
*/
static int GrabTimeStamp(uint32_t *sec_h_ptr, uint32_t *sec_l_ptr, uint32_t *nsc_ptr, uint32_t *ptp_infor_ptr)
{

	UINTPTR QUE_STATUS_ADDR, CTRL_ADDR;
	UINTPTR TSU_DATA_HH_ADDR, TSU_DATA_HL_ADDR, TSU_DATA_LH_ADDR, TSU_DATA_LL_ADDR;
	printf("GrabTimeStamp.\r\n");
//	switch (BufferPtr[2])
//	{
//	case 0x01:
//		// Recv frame from port 0.
//		QUE_STATUS_ADDR = base_ptr + PORT_0_TSU_RXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_0_TSU_RXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_0_TSU_RXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_0_TSU_RXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_0_TSU_RXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_0_TSU_RXQUE_DATA_LL;
//		printf("    Received frame from port 0.\r\n");
//		break;
//	case 0x02:
//		// Sent frame to port 0.
//		QUE_STATUS_ADDR = base_ptr + PORT_0_TSU_TXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_0_TSU_TXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_0_TSU_TXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_0_TSU_TXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_0_TSU_TXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_0_TSU_TXQUE_DATA_LL;
//		printf("    Sent frame to port 0.\r\n");
//		break;
//	case 0x04:
//		// Recv frame from port 1.
//		QUE_STATUS_ADDR = base_ptr + PORT_1_TSU_RXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_1_TSU_RXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_1_TSU_RXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_1_TSU_RXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_1_TSU_RXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_1_TSU_RXQUE_DATA_LL;
//		printf("    Received frame from port 1.\r\n");
//		break;
//	case 0x08:
//		// Sent frame to port 1.
//		QUE_STATUS_ADDR = base_ptr + PORT_1_TSU_TXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_1_TSU_TXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_1_TSU_TXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_1_TSU_TXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_1_TSU_TXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_1_TSU_TXQUE_DATA_LL;
//		printf("    Sent frame to port 1.\r\n");
//		break;
//	case 0x10:
//		// Recv frame from port 2.
//		QUE_STATUS_ADDR = base_ptr + PORT_2_TSU_RXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_2_TSU_RXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_2_TSU_RXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_2_TSU_RXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_2_TSU_RXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_2_TSU_RXQUE_DATA_LL;
//		printf("    Received frame from port 2.\r\n");
//		break;
//	case 0x20:
//		// Sent frame to port 2.
//		QUE_STATUS_ADDR = base_ptr + PORT_2_TSU_TXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_2_TSU_TXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_2_TSU_TXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_2_TSU_TXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_2_TSU_TXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_2_TSU_TXQUE_DATA_LL;
//		printf("    Sent frame to port 2.\r\n");
//		break;
//	case 0x40:
//		// Recv frame from port 3.
//		QUE_STATUS_ADDR = base_ptr + PORT_3_TSU_RXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_3_TSU_RXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_LL;
//		printf("    Received frame from port 3.\r\n");
//		break;
//	case 0x80:
//		// Sent frame to port 3.
//		QUE_STATUS_ADDR = base_ptr + PORT_3_TSU_TXQUE_STATUS;
//		CTRL_ADDR = base_ptr + PORT_3_TSU_TXCTRL;
//		TSU_DATA_HH_ADDR = base_ptr + PORT_3_TSU_TXQUE_DATA_HH;
//		TSU_DATA_HL_ADDR = base_ptr + PORT_3_TSU_TXQUE_DATA_HL;
//		TSU_DATA_LH_ADDR = base_ptr + PORT_3_TSU_TXQUE_DATA_LH;
//		TSU_DATA_LL_ADDR = base_ptr + PORT_3_TSU_TXQUE_DATA_LL;
//		printf("    Sent frame to port 3.\r\n");
//		break;
//	default:
//		printf("GrabTimestamp: Invalid src port section of metadata.\r\n");
//		return XST_FAILURE;
//	}
	QUE_STATUS_ADDR = base_ptr + PORT_3_TSU_RXQUE_STATUS;
	CTRL_ADDR = base_ptr + PORT_3_TSU_RXCTRL;
	TSU_DATA_HH_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_HH;
	TSU_DATA_HL_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_HL;
	TSU_DATA_LH_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_LH;
	TSU_DATA_LL_ADDR = base_ptr + PORT_3_TSU_RXQUE_DATA_LL;
	printf("    Received frame from port 3.\r\n");
	printf("    Poll n_queue.\r\n");
	unsigned int rd_data;
	int n_queue;
	do {
		rd_data = *((unsigned*)(QUE_STATUS_ADDR));
		n_queue = rd_data & 0x00FFFFFF;
		printf("    n_queue: %d\r\n", n_queue);
	} while (n_queue == 0);
	printf("    Set TSU_GET_QUE.\r\n");
	*((unsigned*)(CTRL_ADDR)) = TSU_SET_CTRL_0;
	*((unsigned*)(CTRL_ADDR)) = TSU_GET_QUE;

	do {
		rd_data = *((unsigned*)(CTRL_ADDR));
	} while ((rd_data & TSU_GET_QUE) == 0x0);
	printf("	Ready to fetch tsu data.\r\n");
	// TSU data format (128bit): 16bit 0 + 80 bit timestamp (48 bit seconds + 32 bit nano seconds) + 32 bit ptp_infor (4 bit msg id + 12 bit checksum + 16 bit sequence id).
	unsigned int ts_sec_h, ts_sec_l, ts_nsc, ptp_infor;
	ts_sec_h = *((unsigned*)(TSU_DATA_HH_ADDR));
	ts_sec_l = *((unsigned*)(TSU_DATA_HL_ADDR));
	ts_nsc = *((unsigned*)(TSU_DATA_LH_ADDR));
	ptp_infor = *((unsigned*)(TSU_DATA_LL_ADDR));
	printf("    ts_sec_h: %08X\r\n", ts_sec_h);
	printf("    ts_sec_l: %08X\r\n", ts_sec_l);
	printf("    ts_nsc: %08X\r\n", ts_nsc);
	printf("    ptp_infor: %08X\r\n", ptp_infor);
	int msg_id_ptp_infor = (ptp_infor >> 28) & 0xF;
//	int msg_id_frame = ((int) BufferPtr[FRAME_PTP_MSG_TYPE_OFFSET]) & 0xF;
//	if (msg_id_ptp_infor == msg_id_frame) {
//		printf("    MSG ID check success.\r\n");
//	} else {
//		printf("    MSG ID check fail.\r\n");
//		printf("        msg_id_ptp_infor: %08X, msg_id_frame: %08X\r\n", msg_id_ptp_infor, msg_id_frame);
//		return XST_FAILURE;
//	}
	int checksum_ptp_infor = (ptp_infor & 0x0FFF0000) >> 16;
//	int checksum_frame = CalcCheckSum(BufferPtr, FRAME_PTP_PORT_ID_OFFSET, 10);
//	if (checksum_ptp_infor == checksum_frame) {
//		printf("    CheckSum check success.\r\n");
//	} else {
//		printf("    CheckSum check fail.\r\n");
//		return XST_FAILURE;
//	}
	int seq_id_ptp_infor = (ptp_infor & 0xFFFF);
	// xil_printf("    seq_id_frame: %02X %02X.\r\n", BufferPtr[FRAME_PTP_SEQ_ID_OFFSET], BufferPtr[FRAME_PTP_SEQ_ID_OFFSET+1]);
	// xil_printf("    %08X\r\n", (((int) BufferPtr[FRAME_PTP_SEQ_ID_OFFSET]) & 0xFF));
	// xil_printf("    %08X\r\n", (((int) BufferPtr[FRAME_PTP_SEQ_ID_OFFSET]) & 0xFF) << 8);
	// xil_printf("    %08X\r\n", );
//	int seq_id_frame = ((((int) BufferPtr[FRAME_PTP_SEQ_ID_OFFSET]) & 0xFF) << 8) + (((int) BufferPtr[FRAME_PTP_SEQ_ID_OFFSET + 1]) & 0xFF);
//	if (seq_id_ptp_infor == seq_id_frame) {
//		printf("    Seq ID check success.\r\n");
//	} else {
//		printf("    Seq ID check fail. seq_id_ptp_infor: %08X, seq_id_frame: %08X\r\n", seq_id_ptp_infor, seq_id_frame);
//		return XST_FAILURE;
//	}
	printf("    Timestamp: %08X %08X sec, %08X nsc.\r\n", ts_sec_h, ts_sec_l, ts_nsc);

	*sec_h_ptr = ts_sec_h;
	*sec_l_ptr = ts_sec_l;
	*nsc_ptr = ts_nsc;
	*ptp_infor_ptr = ptp_infor;

	return XST_SUCCESS;
}
/*
 * This function set the tx buffer to 0s.
 */
static void ClearTxBuffer()
{
	uint8_t *TxBufferPtr;
	TxBufferPtr = (uint8_t *)TX_BUFFER_BASE;
	memset(TxBufferPtr, 0, MAX_PKT_LEN);
}
/*
 * This function set the output port of the frame in the tx buffer.
 * Actually it writes the the src port section of the metadata.
 * The switch lut module will determin output ports based on src
 * port.
 */
static void SetDstPort(uint8_t DstPortB)
{
	uint8_t *TxBufferPtr;
	TxBufferPtr = (uint8_t *)TX_BUFFER_BASE;
	// This actually write the the src port section of the metadata.
	TxBufferPtr[2] = DstPortB;
}
/*
 * This function set the dst and src mac address of the tx frame.
 */
static void SetTxBuffer(int MacType)
{
	uint8_t *TxBufferPtr;
	TxBufferPtr = (uint8_t *)TX_BUFFER_BASE;
	switch (MacType) {
		case MAC_ADDR_TYPE_PTP:
			TxBufferPtr[CPU_HEADER_LENGTH] = 0x01;
			TxBufferPtr[CPU_HEADER_LENGTH+1] = 0x80;
			TxBufferPtr[CPU_HEADER_LENGTH+2] = 0xC2;
			TxBufferPtr[CPU_HEADER_LENGTH+3] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+4] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+5] = 0x0E;

			TxBufferPtr[CPU_HEADER_LENGTH+6] = 0x33;
			TxBufferPtr[CPU_HEADER_LENGTH+7] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+8] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+9] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+10] = 0x00;
			TxBufferPtr[CPU_HEADER_LENGTH+11] = 0x33;

			TxBufferPtr[CPU_HEADER_LENGTH+12] = 0x88;
			TxBufferPtr[CPU_HEADER_LENGTH+13] = 0xF7;

			TxBufferPtr[FRAME_PTP_MSG_TYPE_OFFSET] = 0x02; // Pdelay req

			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET] = 0x00;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+1] = 0x00;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+2] = 0x01;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+3] = 0x02;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+4] = 0x04;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+5] = 0x08;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+6] = 0x10;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+7] = 0x20;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+8] = 0x40;
			TxBufferPtr[FRAME_PTP_PORT_ID_OFFSET+9] = 0x80;

			TxBufferPtr[FRAME_PTP_SEQ_ID_OFFSET] = 0xFF;
			TxBufferPtr[FRAME_PTP_SEQ_ID_OFFSET+1] = 0xFF;
			break;
		default:
			printf("Error! Unkown MacType.");
	}

}
static int SendETHFrame(uint8_t dst_port)
{
	int Status;
	uint8_t *TxBufferPtr;
	TxBufferPtr = (uint8_t *)TX_BUFFER_BASE;

	ClearTxBuffer();
	// Assemble the ETHFrame in TxBufferPtr
	// Dst mac
	SetDstPort(dst_port);
	SetTxBuffer(MAC_ADDR_TYPE_PTP);
}
/*
 * In TSUTest, we send back a PTP frame to the same port that we received a PTP frame.
 * This function get the src port of the frame to be sent.
 */
static uint8_t GetRespPort()
{
	uint8_t *RxPacket;
	RxPacket = (uint8_t *) RX_BUFFER_BASE;
	return RxPacket[2] << 1;
}
void TSUTest(uint16_t DeviceId)
{
	printf("TSUTest starts.\r\n");
	printf("Wati for frame from PC.\r\n");

	int Status;
	uint8_t *TxBufferPtr;
	uint8_t *RxBufferPtr;

	TxBufferPtr = (uint8_t *)TX_BUFFER_BASE;
	RxBufferPtr = (uint8_t *)RX_BUFFER_BASE;




	// We received a packet.
	uint64_t curTime = (uint64_t)time(NULL);
//		XTime_GetTime(&curTime);
	printf("Recv packet at 0x%08x_0x%08x clock cycles.\r\n", (unsigned int) (curTime >> 32), (unsigned int) (curTime & 0x00000000FFFFFFFF));
//		ParseETHData();

	uint32_t sec_h, sec_l, nsc, ptp_infor;
	GrabTimeStamp(&sec_h, &sec_l, &nsc, &ptp_infor);

	// Send back a PTP frame to this port.
	uint8_t resp_port = GetRespPort();
//		XTime_GetTime(&curTime);
	curTime = (uint64_t)time(NULL);
	printf("resp port: %02X \r\n", resp_port);
	printf("Send packet at 0x%08x_0x%08x clock cycles.\r\n", (unsigned int) (curTime >> 32), (unsigned int) (curTime & 0x00000000FFFFFFFF));
//	SendETHFrame(resp_port);

	GrabTimeStamp(&sec_h, &sec_l, &nsc, &ptp_infor);

	printf("TSUTest ends.");
}

void TSUTest_wjh(){
	void *ptr;
	ptr = uio_init("/dev/uio0");
	tsu_init(ptr);
	int tx_ts_status;
	TSUTimestamp tsu_tx_ts;
	tx_ts_status = tsu_rx_get_timestamp(4, &tsu_tx_ts);
}

void SwitchRuleTest() {
	void *ptr;
	ptr = switch_rule_uio_init();
	switch_rule_init(ptr); // clear all existing rules.
	char mac_addr_0[6] = {0x00, 0x00, 0x00, 0x00, 0x01, 0x02};
	int output_port_0 = 4;
	char mac_addr_1[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x01};
	int output_port_1 = 3;
	char mac_addr_2[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x02};
	int output_port_2 = 2;
	char mac_addr_3[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x03};
	int output_port_3 = 1;
	char mac_addr_4[6] = {0x00, 0x00, 0x00, 0x04, 0x00, 0x04};
	int output_port_4 = 0;
	push_switch_rule(mac_addr_0, output_port_0);
	push_switch_rule(mac_addr_1, output_port_1);
	push_switch_rule(mac_addr_2, output_port_2);
	push_switch_rule(mac_addr_3, output_port_3);
	push_switch_rule(mac_addr_4, output_port_4);
}

void GCLTest() {
	void *ptr;
	ptr = uio_init("/dev/uio0");
	gcl_init(ptr);
	printf("GCL init complete. \r\n");
	int get_gcl_status;
	printf("get GCL list: \r\n");
	// get_gcl_status = get_gcl(1);
	// get_gcl_status = get_gcl(2);
	// get_gcl_status = get_gcl(3);
	while (1) {
		printf("get port 4's gcl\n");
		get_gcl_status = get_gcl(4);
		sleep(1);
	}
//	printf("set GCL[2] to %08x: \r\n", 9);
	// for (int i = 0; i < 8; i++) {
	// 	set_gcl(4, i, 1);
	// 	set_gcl(3, i, 1);
	// 	set_gcl(2, i, 1);
	// 	set_gcl(1, i, 1);
	// }
	// for (int i = 8; i < 16; i++) {
	// 	set_gcl(4, i, 0);
	// 	set_gcl(3, i, 0);
	// 	set_gcl(2, i, 0);
	// 	set_gcl(1, i, 0);
	// }
	// for (int i = 0; i < 8; i++) {
	// 	set_gcl_time_interval(4, i, 0x400);
	// 	set_gcl_time_interval(3, i, 0x400);
	// 	set_gcl_time_interval(2, i, 0x400);
	// 	set_gcl_time_interval(1, i, 0x400);
	// }
	// for (int i = 8; i < 16; i++) {
	// 	set_gcl_time_interval(4, i, 0x400);
	// 	set_gcl_time_interval(3, i, 0x400);
	// 	set_gcl_time_interval(2, i, 0x400);
	// 	set_gcl_time_interval(1, i, 0x400);
	// }
	// for (int i = 0; i < 8; i++) {
	// 	set_gcl_time_interval(4, i, (uint16_t)(0x400 / 4));
	// 	set_gcl_time_interval(3, i, (uint16_t)(0x400 / 4));
	// 	set_gcl_time_interval(2, i, (uint16_t)(0x400 / 4));
	// 	set_gcl_time_interval(1, i, (uint16_t)(0x400 / 4));
	// }
	// for (int i = 8; i < 16; i++) {
	// 	set_gcl_time_interval(4, i, (uint16_t)(0x400 * 7 / 4));
	// 	set_gcl_time_interval(3, i, (uint16_t)(0x400 * 7 / 4));
	// 	set_gcl_time_interval(2, i, (uint16_t)(0x400 * 7 / 4));
	// 	set_gcl_time_interval(1, i, (uint16_t)(0x400 * 7 / 4));
	// }
	

//	printf("get GCL list: \r\n");
//	get_gcl_status = get_gcl(4);
//	printf("set GCL[3] to %08x: \r\n", 20);
//	set_gcl(4, 3, 20);
//	printf("get GCL list: \r\n");
//	get_gcl_status = get_gcl(4);
}

void TaggerTest() {
	void *ptr;
	ptr = uio_init("/dev/uio0");
	printf("Tagger init. \r\n");
	tagger_init(ptr);
	printf("Tagger init complete. \r\n");
	printf("Get Port 4 Tagger status: %d \n", check_tagger_status(4));
	printf("Get Port 3 Untagger status: %d \n", check_untagger_status(3));
	printf("Get Port 4 priority: %d \n", get_priority(4));
	printf("Enable Port 4 Tagger. \r\n");
	enable_tagger(4);
	printf("Set Port 4 Tagger priority to 3. \r\n");
	set_priority(4, 3);
	printf("Enable Port 3 Untagger. \r\n");
	enable_untagger(3);
	printf("Get Port 4 Tagger status: %d \n", check_tagger_status(4));
	printf("Get Port 3 Untagger status: %d \n", check_untagger_status(3));
	printf("Get Port 4 priority: %d \n", get_priority(4));
}

int main(int argc, char *argv[])
{
//	int fd;
//	char *uiod = "/dev/uio0";
//
    printf("TSN hello.\n");
//
//    /* Open the UIO device file */
//    fd = open(uiod, O_RDWR);
//    if (fd < 1) {
//    	printf("Invalid UIO device file:%s!\n", uiod);
//    	return -1;
//    }
//    printf("(fd:%d) UIO device file:%s is valid.\n", fd, uiod);
//
//    /* mmap the UIO device */
//    base_ptr = mmap(NULL, RTC_MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
//    base_ptr_tsu = base_ptr;
//    base_ptr_gcl = base_ptr;
//    if(base_ptr == MAP_FAILED){
//    	perror("mmap() failed\n");
//        return 1;
//    }
//    printf("mmap() success!\n");
//    printf("base_ptr: %p\n", base_ptr);
//    printf("base_ptr_tsu: %p\n", base_ptr_tsu);

    // RTCTest();
	// RTCOFFsetTest();
	// TSUTest(DMA_DEV_ID);
    // TSUTest_wjh();

  // GCLTest();
//	TaggerTest();
	// GCL_time_test();
	SwitchRuleTest();
    return 0;
}
