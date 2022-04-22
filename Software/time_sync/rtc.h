#ifndef RTC_H
#define RTC_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#include "ptp_types.h"

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

void *base_ptr;

void rtc_init(void *ptr);
UScaledNs get_current_timestamp();
int get_current_local_sync_ts(UScaledNs *local, UScaledNs *sync);
int set_rtc_sync_offset(RTC_OFFSET_SIGN sign, UScaledNs *offset);
LocalClockTimestamp rtc_add(LocalClockTimestamp t1, LocalClockTimestamp t2);
int rtc_comp(LocalClockTimestamp t1, LocalClockTimestamp t2);
void rtc_print_timestamp(LocalClockTimestamp t);
uint64_t rtc_to_uint64_ns(LocalClockTimestamp t);


#endif
