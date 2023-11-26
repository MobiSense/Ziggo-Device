/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-12 22:50:53
 * @FilePath: /linux_uio_app/tagger.h
 * @Description: 
 */
#ifndef TAGGER_H
#define TAGGER_H
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


// define tagger address values Port 0
#define PORT_0_TAGGER_CTRL   0x00000260
#define PORT_0_TAGGER        0x00000264
#define PORT_0_UNTAGGER      0x00000268
#define PORT_0_PRIORITY      0x0000026C
// define tagger address values Port 1
#define PORT_1_TAGGER_CTRL   0x00000270
#define PORT_1_TAGGER        0x00000274
#define PORT_1_UNTAGGER      0x00000278
#define PORT_1_PRIORITY      0x0000027C
// define tagger address values Port 2
#define PORT_2_TAGGER_CTRL   0x00000280
#define PORT_2_TAGGER        0x00000284
#define PORT_2_UNTAGGER      0x00000288
#define PORT_2_PRIORITY      0x0000028C
// define tagger address values Port 3
#define PORT_3_TAGGER_CTRL   0x00000290
#define PORT_3_TAGGER        0x00000294
#define PORT_3_UNTAGGER      0x00000298
#define PORT_3_PRIORITY      0x0000029C
// define tagger control values
#define TAGGER_SET_CTRL_0    0x00
#define SET_TAGGER           0x01
#define SET_UNTAGGER         0x02
#define SET_PRIORITY         0x04
// define tagger data values
#define TAGGER_VALUE_0       0x00000000

void *base_ptr_tagger;
int tagger_init(void *ptr);
int set_tagger(uint16_t portNumber, int value);
int set_untagger(uint16_t portNumber, int value);
int enable_tagger(uint16_t portNumber);
int enable_untagger(uint16_t portNumber);
int disable_tagger(uint16_t portNumber);
int disable_untagger(uint16_t portNumber);
int set_priority(uint16_t portNumber, uint16_t priority);
int get_priority(uint16_t portNumber);
int check_tagger_status(uint16_t portNumber);
int check_untagger_status(uint16_t portNumber);

#ifdef __cplusplus
}
#endif
#endif
