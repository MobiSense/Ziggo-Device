#ifndef TSU_H
#define TSU_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#include "ptp_types.h"

typedef enum TSU_FETCH_STATUS {
    TSU_FETCH_FAILURE = 0,
    TSU_FETCH_SUCCESS = 1,
} TSU_FETCH_STATUS;
void *base_ptr_tsu;
int tsu_init(void *ptr);
int tsu_tx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp);
int tsu_rx_get_timestamp(uint16_t portNumber, TSUTimestamp *tsuTimestamp);

#endif
