#include "ptp_types.h"

#include <assert.h>
#include <math.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>

void ptp_msg_header_template(PTPMsgHeader *head, PTPMsgType msgtype,
                             uint16_t len, PortIdentity *portId, uint16_t seqid,
                             int8_t logMessageInterval, int64_t correction) {
    head->majorSdoId = 1;
    head->messageType = msgtype;
    head->minorVersionPTP = 1;
    head->versionPTP = 2;
    head->messageLength = len;
    head->domainNumber = 0;
    head->minorSdoId = 0;
    head->flags[0] = 0x2;
    head->flags[1] = 0x0;
    head->correctionField = correction;
    memset(head->messageTypeSpecific, 0, 4);
    memcpy(&head->sourcePortIdentity, portId, sizeof(PortIdentity));
    head->sequenceId = seqid;
    switch (msgtype) {
        case SYNC:
            head->controlField = 0x0;
            break;
        case FOLLOW_UP:
            head->controlField = 0x2;
            break;
        default:
            head->controlField = 0x5;
            break;
    }
    head->logMessageInterval = logMessageInterval;
}

// This is for setting the header of Announce information.
// 10.6.2.2
void ptp_msg_ann_header_template(PTPMsgHeader *head, PTPMsgType msgtype,
                                 uint16_t len, PortIdentity *portId,
                                 uint16_t seqid, int8_t logMessageInterval,
                                 int64_t correction,
                                 PerPTPInstanceGlobal *perPTPInstanceGlobal) {
    head->majorSdoId = 1;
    head->messageType = msgtype;
    head->minorVersionPTP = 1;
    head->versionPTP = 2;
    head->messageLength = len;
    head->domainNumber = 0;
    head->minorSdoId = 0;
    head->flags[0] = 0x0;  // Set as in Table 10-9
    head->flags[1] = 0x0;
    if (perPTPInstanceGlobal->leap61) head->flags[1] |= FLAG_MASK_LEAP61;
    if (perPTPInstanceGlobal->leap59) head->flags[1] |= FLAG_MASK_LEAP59;
    if (perPTPInstanceGlobal->currentUtcOffsetValid)
        head->flags[1] |= FLAG_MASK_UTC_OFFSET;
    if (perPTPInstanceGlobal->ptpTimescale)
        head->flags[1] |= FLAG_MASK_PTP_TIMESCALE;
    if (perPTPInstanceGlobal->timeTraceable)
        head->flags[1] |= FLAG_MASK_TIME_TRACEABLE;
    if (perPTPInstanceGlobal->frequencyTraceable)
        head->flags[1] |= FLAG_MASK_FREQ_TRACEABLE;
    head->correctionField = correction;
    memset(head->messageTypeSpecific, 0, 4);
    memcpy(&head->sourcePortIdentity, portId, sizeof(PortIdentity));
    head->sequenceId = seqid;
    switch (msgtype) {
        case ANNOUNCE:
            head->controlField = 0x0;
            break;
        default:
            head->controlField = 0x0;
            break;
    }
    head->logMessageInterval = logMessageInterval;
}

UScaledNs uscaledns_subtract(UScaledNs t1, UScaledNs t2) {
    uint8_t borrow;
    UScaledNs r;
    if (t1.subns >= t2.subns) {
        r.subns = t1.subns - t2.subns;
        borrow = 0;
    } else {
        r.subns = t1.subns - t2.subns;
        borrow = 1;
    }
    if (t1.nsec == 0 && borrow == 1) {
        r.nsec = (uint64_t)0xFFFFFFFFFFFFFFFF - t2.nsec;
        borrow = 1;
    } else if (t1.nsec - borrow >= t2.nsec) {
        r.nsec = t1.nsec - borrow - t2.nsec;
        borrow = 0;
    } else {
        r.nsec = t1.nsec - borrow - t2.nsec;
        borrow = 1;
    }
    if (t1.nsec_msb == 0 && borrow == 1) {
        r.nsec_msb = (uint16_t)0xFFFF - t2.nsec_msb;
        borrow = 1;
    } else if (t1.nsec_msb - borrow >= t2.nsec_msb) {
        r.nsec_msb = t1.nsec_msb - borrow - t2.nsec_msb;
        borrow = 0;
    } else {
        r.nsec_msb = t1.nsec_msb - borrow - t2.nsec_msb;
        borrow = 1;
    }
    return r;
}

static int check_overflow(uint64_t a, uint64_t b, uint8_t carry) {
    uint64_t s = a + b + carry;
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

UScaledNs uscaledns_add(UScaledNs t1, UScaledNs t2) {
    uint8_t c;
    UScaledNs r;
    uint64_t temp;

    temp = (uint64_t)t1.subns + t2.subns;
    c = (temp >= 0xFFFF) ? 1 : 0;
    r.subns = temp & 0xFFFF;

    temp = t1.nsec + t2.nsec + c;
    c = check_overflow(t1.nsec, t2.nsec, c);
    r.nsec = temp;

    temp = t1.nsec_msb + t2.nsec_msb + c;
    r.nsec_msb = temp;
    return r;
}

UScaledNs uscaledns_mul(UScaledNs t1, UScaledNs t2) {
    uint64_t a[4], b[4], c[5];

    a[0] = (uint64_t)t1.subns + ((t1.nsec & 0xffff) << 16);
    a[1] = ((t1.nsec >> 16) & 0xffffffff);
    a[2] = (t1.nsec >> 48) + ((uint64_t)(t1.nsec_msb) << 16);
    a[3] = 0;

    b[0] = (uint64_t)t2.subns + ((t2.nsec & 0xffff) << 16);
    b[1] = ((t2.nsec >> 16) & 0xffffffff);
    b[2] = (t2.nsec >> 48) + ((uint64_t)(t2.nsec_msb) << 16);
    b[3] = 0;

    c[0] = c[1] = c[2] = c[3] = c[4] = 0;

    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++) {
            c[i + j] += a[i] * b[j];
        }
    for (int i = 0; i < 4; i++) {
        c[i + 1] += (c[i] >> 32);
        c[i] &= 0xffffffff;
    }

    UScaledNs r;
    r.subns = (uint16_t)(c[0] >> 16);
    r.nsec = c[1] + (c[2] << 16);
    r.nsec_msb = (uint16_t)(c[3] & 0xffff);

    return r;
}

UScaledNs uscaledns_mul_double(UScaledNs t1, double r) {
    return uscaledns_mul(t1, uscaledns_double(r));
}

int compare_array(uint64_t a[], uint64_t b[], size_t size) {
    for (int i = (int)size - 1; i >= 0; i--) {
        if (a[i] == b[i]) continue;
        return (a[i] < b[i]) ? -1 : 1;
    }
    return 0;
}

double uscaledns_div(UScaledNs t1, UScaledNs t2) {
    uint64_t a[4], b[4];

    a[0] = (uint64_t)t1.subns + ((t1.nsec & 0xffff) << 16);
    a[1] = ((t1.nsec >> 16) & 0xffffffff);
    a[2] = (t1.nsec >> 48) + ((uint64_t)(t1.nsec_msb) << 16);
    a[3] = 0;

    b[0] = (uint64_t)t2.subns + ((t2.nsec & 0xffff) << 16);
    b[1] = ((t2.nsec >> 16) & 0xffffffff);
    b[2] = (t2.nsec >> 48) + ((uint64_t)(t2.nsec_msb) << 16);
    b[3] = 0;

    int k = 0;
    // (a > b)
    while (compare_array(a, b, 4) > 0) {
        // b *= 2
        int carry_bit = 0;
        for (int i = 0; i < 4; i++) {
            int carry_bit_tmp = b[i] >> 31;
            b[i] = ((b[i] << 1) + carry_bit) & 0xffffffff;
            carry_bit = carry_bit_tmp;
        }
        assert(carry_bit == 0);

        k++;
    }

    if (compare_array(a, b, 4) == 0) return pow(2, k);

    double r = 0;
    // calc a / (2^k b)
    for (int i = k + 31; i >= 0; i--) {
        // a *= 2
        uint64_t carry_bit = 0;
        for (int j = 0; j < 4; j++) {
            uint64_t carry_bit_tmp = a[j] >> 31;
            a[j] = ((a[j] << 1) + carry_bit) & 0xffffffff;
            carry_bit = carry_bit_tmp;
        }
        assert(carry_bit == 0);

        int compare_result = compare_array(a, b, 4);
        if (compare_result >= 0) {
            // substract
            uint64_t carry_bit = 0;
            for (int j = 0; j < 4; j++) {
                uint64_t carry_bit_tmp = (a[j] < b[j] + carry_bit) ? 1 : 0;
                a[j] = a[j] + (carry_bit_tmp << 32) - b[j] - carry_bit;
                carry_bit = carry_bit_tmp;
            }
            assert(carry_bit == 0);

            r += pow(2, i - 32);
            if (compare_result == 0) return r;
        }
    }

    return r;
}

UScaledNs uscaledns_divide_by_2(UScaledNs t) {
    UScaledNs r;
    r.subns = t.subns >> 1;
    if (t.nsec & 0x1) {
        r.subns = r.subns | 0x8000;
    }
    r.nsec = t.nsec >> 1;
    if (t.nsec_msb & 0x1) {
        r.nsec = r.nsec | 0x8000000000000000;
    }
    r.nsec_msb = t.nsec_msb >> 1;
    return r;
}

void print_uscaledns(UScaledNs t) {
    uint32_t *ns_h, *ns_l;
    ns_l = &t.nsec;
    ns_h = ns_l + 1;
    printf("%04X ns_msb ", t.nsec_msb);
    printf("%08X %08X ns ", *ns_h, *ns_l);
    printf("%04X subns\r\n", t.subns);
}

int uscaledns_compare(UScaledNs t1, UScaledNs t2) {
    if (t1.nsec_msb > t2.nsec_msb) {
        return 1;
    } else if (t1.nsec_msb < t2.nsec_msb) {
        return -1;
    } else if (t1.nsec > t2.nsec) {
        return 1;
    } else if (t1.nsec < t2.nsec) {
        return -1;
    } else if (t1.subns > t2.subns) {
        return 1;
    } else if (t1.subns < t2.subns) {
        return -1;
    } else {
        return 0;
    }
}

uint64_t uint64_uscaledns(UScaledNs t) {
    uint64_t r;
    r = t.subns;
    r = r | (t.nsec << 16);
    return r;
}

UScaledNs uscaledns_uint64(uint64_t t) {
    UScaledNs r;
    r.nsec_msb = 0;
    r.subns = t & 0xFFFF;
    r.nsec = t >> 16;
    return r;
}

int portIdentityEqual(PortIdentity pi1, PortIdentity pi2) {
    bool check1 = !memcmp(pi1.clockIdentity, pi2.clockIdentity, 8);
    bool check2 = pi1.portNumber == pi2.portNumber;
    return check1 && check2;
}

UScaledNs uscaledns_ptpmsgtimestamp(PTPMsgTimestamp ptpmsgts) {
    // TODO this is incomplete. But it is enough for tens of years.
    UScaledNs r;
    r.nsec_msb = 0;
    r.nsec = (uint64_t)ptpmsgts.seconds_lsb * 1000000000 + ptpmsgts.nanoseconds;
    r.subns = 0;
    return r;
}

PTPMsgTimestamp ptpmsgtimestamp_uscaledns(UScaledNs usns) {
    PTPMsgTimestamp r;
    r.seconds_msb = 0;
    r.seconds_lsb = usns.nsec / 1000000000;
    r.nanoseconds = usns.nsec % 1000000000;
    return r;
}

void set_default_clock_identity(uint8_t *clock_identity) {
    uint32_t *clock_identity_l, *clock_identity_h;
    clock_identity_l = (uint32_t *)clock_identity;
    clock_identity_h = clock_identity_l + 1;
    *clock_identity_l = DEFAULT_CLOCK_IDENTITY_L;
    *clock_identity_h = DEFAULT_CLOCK_IDENTITY_H;
}

PTPMsgTimestamp ptpmsgtimestamp_extendedtimestamp(ExtendedTimestamp ts) {
    return ptpmsgtimestamp_uscaledns((UScaledNs)ts);
}

UScaledNs uscaledns_double(double r) {
    UScaledNs t;

    t.nsec = (uint64_t)(floor(r));
    t.nsec_msb =
        (uint16_t)(floor(r) / (1 << 16) / (1 << 16) / (1 << 16) / (1 << 16));
    t.subns = 0;
    r -= floor(r);
    for (int i = 0; i < 16; i++) {
        if (r * 2 > 1) {
            t.subns |= 1 << (15 - i);
            r = r * 2 - 1;
        } else
            r = r * 2;
    }
    // rounding
    if (r * 2 > 1) {
        if (t.subns == 0xffff) {
            t.subns = 0;
            if (t.nsec == 0xffffffffffffffff) {
                t.nsec = 0;
                t.nsec_msb++;
            } else {
                t.nsec++;
            }
        } else {
            t.subns++;
        }
    }

    return t;
}
void print_path_trace(uint8_t *pathTrace) {
    uint64_t toPrint;
    memcpy(&toPrint, pathTrace, 8);
    printf("%" PRIu64 "\r\n", toPrint);
}
