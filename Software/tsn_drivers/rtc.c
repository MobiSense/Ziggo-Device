#include "rtc.h"

#include <inttypes.h>

void *base_ptr;

/**
 * @description: This function is used to init rtc module.
 * @param {void} *ptr uio base ptr.
 * @return {void}
 */
void rtc_init(void *ptr) { base_ptr = ptr; }

/**
 * @description: This function is used to get current local time.
 * @param {*}
 * @return {UScaledNs} current local time.
 */
UScaledNs get_current_timestamp() {
    LocalClockTimestamp current_time;
    int data_o;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_GET_TIME;
    do {
        data_o = *((unsigned *)(base_ptr + RTC_CTRL));
    } while ((data_o & RTC_GET_TIME) == 0x0);

    current_time.second_h = *((unsigned *)(base_ptr + RTC_TIME_SEC_H));
    current_time.second_l = *((unsigned *)(base_ptr + RTC_TIME_SEC_L));
    current_time.nanosecond = *((unsigned *)(base_ptr + RTC_TIME_NSC_H));
    current_time.frac_nano = *((unsigned *)(base_ptr + RTC_TIME_NSC_L));
    // printf("current_time.second_h: %08x\n", current_time.second_h);
    // printf("current_time.second_l: %08x\n", current_time.second_l);
    // printf("current_time.nanosecond: %08x\n", current_time.nanosecond);
    // printf("current_time.frac_nano : %08x\n", current_time.frac_nano);

    UScaledNs current_ts;
    current_ts.subns = (current_time.frac_nano << 8) & 0xFF00;
    // This is incomplete, but enough.
    current_ts.nsec =
        (uint64_t)current_time.second_l * 1000000000 + current_time.nanosecond;
    current_ts.nsec_msb = 0;
    // printf("RTC timestamp is %" PRIu64 "\n", current_ts.nsec);
    return current_ts;
}

/**
 * @description: This function is used to get local time and sync time.
 * @param {UScaledNs} *local local time ptr.
 * @param {UScaledNs} *sync sync time ptr.
 * @return {int} 0 by default.
 */
int get_current_local_sync_ts(UScaledNs *local, UScaledNs *sync) {
    LocalClockTimestamp current_time, sync_current_time;
    int data_o;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_GET_TIME;
    do {
        data_o = *((unsigned *)(base_ptr + RTC_CTRL));
    } while ((data_o & RTC_GET_TIME) == 0x0);

    current_time.second_h = *((unsigned *)(base_ptr + RTC_TIME_SEC_H));
    current_time.second_l = *((unsigned *)(base_ptr + RTC_TIME_SEC_L));
    current_time.nanosecond = *((unsigned *)(base_ptr + RTC_TIME_NSC_H));
    current_time.frac_nano = *((unsigned *)(base_ptr + RTC_TIME_NSC_L));

    sync_current_time.second_h = *((unsigned *)(base_ptr + RTC_SYNT_SEC_H));
    sync_current_time.second_l = *((unsigned *)(base_ptr + RTC_SYNT_SEC_L));
    sync_current_time.nanosecond = *((unsigned *)(base_ptr + RTC_SYNT_NSC));
    sync_current_time.frac_nano = 0;

    local->subns = (current_time.frac_nano << 8) & 0xFF00;
    // This is incomplete, but enough.
    local->nsec =
        (uint64_t)current_time.second_l * 1000000000 + current_time.nanosecond;
    local->nsec_msb = 0;

    sync->subns = (sync_current_time.frac_nano << 8) & 0xFF00;
    // This is incomplete, but enough.
    sync->nsec = (uint64_t)sync_current_time.second_l * 1000000000 +
                 sync_current_time.nanosecond;
    sync->nsec_msb = 0;
    return XST_SUCCESS;
}

/**
 * @description:
 * @param {RTC_OFFSET_SIGN} sign
 * @param {UScaledNs} *offset
 * @return {*}
 */
int set_rtc_sync_offset(RTC_OFFSET_SIGN sign, UScaledNs *offset) {
    uint32_t sec_h = 0;
    uint32_t sec_l = offset->nsec / RTC_ACCMOD_H;
    uint32_t ns = offset->nsec % RTC_ACCMOD_H;
    // xil_printf("%d %d\r\n", sec_l, ns);
    if (sign == RTC_OFFSET_ADD) {
        sec_h = 0;
    } else {
        sec_h = 0x8000;
    }
    *((unsigned *)(base_ptr + RTC_OFFSET_S_H)) = sec_h;
    *((unsigned *)(base_ptr + RTC_OFFSET_S_L)) = sec_l;
    *((unsigned *)(base_ptr + RTC_OFFSET_NS)) = ns;

    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_OFFSET;
}

/**
 * @description:
 * @param {uint32_t} a
 * @param {uint32_t} b
 * @param {uint32_t} carry
 * @return {*}
 */
static int check_overflow(uint32_t a, uint32_t b, uint32_t carry) {
    uint32_t s = a + b + carry;
    if (carry == 0) {
        if (s < a) {
            return 1;
        } else {
            return 0;
        }
    } else {
        if (s > a) {
            return 0;
        } else {
            return 1;
        }
    }
}

/**
 * @description:
 * @param {LocalClockTimestamp} t1
 * @param {LocalClockTimestamp} t2
 * @return {*}
 */
LocalClockTimestamp rtc_add(LocalClockTimestamp t1, LocalClockTimestamp t2) {
    uint32_t temp;
    uint32_t c;
    LocalClockTimestamp sum;

    temp = t1.frac_nano + t2.frac_nano;
    if (temp >= 0x100) {
        c = 1;
        temp = temp & 0xFF;
    } else {
        c = 0;
    }
    sum.frac_nano = temp;

    temp = t1.nanosecond + t2.nanosecond + c;
    if (temp >= 1000000000) {
        c = 1;
        temp = temp - 1000000000;
    } else {
        c = 0;
    }
    sum.nanosecond = temp;

    temp = t1.second_l + t2.second_l + c;
    c = check_overflow(t1.second_l, t2.second_l, c);
    sum.second_l = temp;

    temp = t1.second_h + t2.second_h + c;
    sum.second_h = temp & 0xFFFF;

    return sum;
}

/**
 * @description:
 * @param {LocalClockTimestamp} t1
 * @param {LocalClockTimestamp} t2
 * @return {*}
 */
int rtc_comp(LocalClockTimestamp t1, LocalClockTimestamp t2) {
    if (t1.second_h > t2.second_h) {
        return 1;
    } else if (t1.second_h < t2.second_h) {
        return -1;
    } else if (t1.second_l > t2.second_l) {  // second_h is equal.
        return 1;
    } else if (t1.second_l < t2.second_l) {
        return -1;
    } else if (t1.nanosecond >
               t2.nanosecond) {  // second_h and second_l are both equal.
        return 1;
    } else if (t1.nanosecond < t2.nanosecond) {
        return -1;
    } else if (t1.frac_nano > t2.frac_nano) {
        return 1;
    } else if (t1.frac_nano < t2.frac_nano) {
        return -1;
    } else {
        return 0;
    }
}

/**
 * @description:
 * @param {LocalClockTimestamp} t
 * @return {*}
 */
void rtc_print_timestamp(LocalClockTimestamp t) {
    printf("%08X %08X sec, %08X ns, %08X frac ns. \r\n", t.second_h, t.second_l,
           t.nanosecond, t.frac_nano);
}

/**
 * @description:
 * @param {LocalClockTimestamp} t
 * @return {*}
 */
uint64_t rtc_to_uint64_ns(LocalClockTimestamp t) {
    uint64_t ts64 = 0;
    uint64_t sec_h = t.second_h;
    ts64 = ts64 + (sec_h << 32) * 1000000000;
    ts64 = ts64 + t.second_l * 1000000000;
    ts64 = ts64 + t.nanosecond;
    return ts64;
}

/**
 * @brief This function set the period of the hardware clock.
 *
 * @param period_h The int part of the period (in nanoseconds), only lower 8
 * bits are valid.
 * @param period_l The fraction part of the period (in nanoseconds).
 * For example, period_h=8, period_l=0 set the period to 8ns.
 */
void rtc_set_period(uint32_t period_h, uint32_t period_l) {
    // double period_print = (((uint64_t)period_h << 32) | (uint64_t)period_l) /
    //                       (double)(1 << 16) / (double)(1 << 16);
    // printf("**** set period = %x.%x = %.6lf ****", period_h, period_l,
    //        period_print);
    *((unsigned *)(base_ptr + RTC_PERIOD_H)) = period_h;
    *((unsigned *)(base_ptr + RTC_PERIOD_L)) = period_l;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_CTRL_0;
    *((unsigned *)(base_ptr + RTC_CTRL)) = RTC_SET_PERIOD;
}
