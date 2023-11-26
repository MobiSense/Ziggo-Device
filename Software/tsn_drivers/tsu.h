#ifndef TSU_H
#define TSU_H
#ifdef __cplusplus
extern "C"{
#endif
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#include "ptp_types.h"


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
// define TSU data values
#define TSU_MASK_RXMSGID 0x0D000000  // 8'b0000_1101
#define TSU_MASK_TXMSGID 0x0D000000  // 8'b0000_1101

typedef enum TSU_FETCH_STATUS {
    TSU_FETCH_FAILURE = 0,
    TSU_FETCH_SUCCESS = 1,
} TSU_FETCH_STATUS;

void *base_ptr_tsu;
int tsu_init(void *ptr);
int tsu_tx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp);
int tsu_rx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp);

#ifdef __cplusplus
}
#endif
#endif
