/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-12 23:01:41
 * @FilePath: /linux_uio_app/rtc.h
 * @Description: 
 */
#ifndef RTC_H
#define RTC_H
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
#define RTC_OFFSET_S_H 0x00000034
#define RTC_OFFSET_S_L 0x00000038
#define RTC_OFFSET_NS  0x0000003C
#define RTC_SYNT_SEC_H 0x00000140
#define RTC_SYNT_SEC_L 0x00000144
#define RTC_SYNT_NSC   0x00000148
// define RTC control values
#define RTC_SET_CTRL_0 0x00
#define RTC_GET_TIME   0x01
#define RTC_SET_ADJ    0x02
#define RTC_SET_PERIOD 0x04
#define RTC_SET_TIME   0x08
#define RTC_SET_RESET  0x10
#define RTC_SET_OFFSET 0x20
// define RTC data values
#define RTC_SET_PERIOD_H 0x16     // 16ns for double speed clock
#define RTC_SET_PERIOD_L 0x0
// define RTC constant
#define RTC_ACCMOD_H 0x3B9ACA00  // 1,000,000,000 for 30bit
#define RTC_ACCMOD_L 0x0         // 256 for 8bit

typedef struct LocalClockTimestamp {
	uint32_t second_h;
	uint32_t second_l;
	uint32_t nanosecond;
	uint32_t frac_nano;
} LocalClockTimestamp;

typedef enum RTC_OFFSET_SIGN {
	RTC_OFFSET_ADD,
	RTC_OFFSET_SUB,
} RTC_OFFSET_SIGN;

extern void *base_ptr;

void rtc_init(void *ptr);
UScaledNs get_current_timestamp();
int get_current_local_sync_ts(UScaledNs *local, UScaledNs *sync);
int set_rtc_sync_offset(RTC_OFFSET_SIGN sign, UScaledNs *offset);
LocalClockTimestamp rtc_add(LocalClockTimestamp t1, LocalClockTimestamp t2);
int rtc_comp(LocalClockTimestamp t1, LocalClockTimestamp t2);
void rtc_print_timestamp(LocalClockTimestamp t);
uint64_t rtc_to_uint64_ns(LocalClockTimestamp t);
void rtc_set_period(uint32_t period_h, uint32_t period_l);

#ifdef __cplusplus
}
#endif

#endif
