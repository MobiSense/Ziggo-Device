#ifndef GCL_H
#define GCL_H
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



// define GCL address values Port 0
#define PORT_0_GCL_CTRL  0x00000150
#define PORT_0_GCL_0     0x00000154
#define PORT_0_GCL_1     0x00000158
#define PORT_0_GCL_2     0x0000015C
#define PORT_0_GCL_3     0x00000160
#define PORT_0_GCL_4     0x00000164
#define PORT_0_GCL_5     0x00000168
#define PORT_0_GCL_6     0x0000016C
#define PORT_0_GCL_7     0x00000170
#define PORT_0_GCL_8     0x00000174
#define PORT_0_GCL_9     0x00000178
#define PORT_0_GCL_10    0x0000017C
#define PORT_0_GCL_11    0x00000180
#define PORT_0_GCL_12    0x00000184
#define PORT_0_GCL_13    0x00000188
#define PORT_0_GCL_14    0x0000018C
#define PORT_0_GCL_15    0x00000190

// define GCL address values Port 1
#define PORT_1_GCL_CTRL  0x00000194
#define PORT_1_GCL_0     0x00000198
#define PORT_1_GCL_1     0x0000019C
#define PORT_1_GCL_2     0x000001A0
#define PORT_1_GCL_3     0x000001A4
#define PORT_1_GCL_4     0x000001A8
#define PORT_1_GCL_5     0x000001AC
#define PORT_1_GCL_6     0x000001B0
#define PORT_1_GCL_7     0x000001B4
#define PORT_1_GCL_8     0x000001B8
#define PORT_1_GCL_9     0x000001BC
#define PORT_1_GCL_10    0x000001C0
#define PORT_1_GCL_11    0x000001C4
#define PORT_1_GCL_12    0x000001C8
#define PORT_1_GCL_13    0x000001CC
#define PORT_1_GCL_14    0x000001D0
#define PORT_1_GCL_15    0x000001D4

// define GCL address values Port 2
#define PORT_2_GCL_CTRL  0x000001D8
#define PORT_2_GCL_0     0x000001DC
#define PORT_2_GCL_1     0x000001E0
#define PORT_2_GCL_2     0x000001E4
#define PORT_2_GCL_3     0x000001E8
#define PORT_2_GCL_4     0x000001EC
#define PORT_2_GCL_5     0x000001F0
#define PORT_2_GCL_6     0x000001F4
#define PORT_2_GCL_7     0x000001F8
#define PORT_2_GCL_8     0x000001FC
#define PORT_2_GCL_9     0x00000200
#define PORT_2_GCL_10    0x00000204
#define PORT_2_GCL_11    0x00000208
#define PORT_2_GCL_12    0x0000020C
#define PORT_2_GCL_13    0x00000210
#define PORT_2_GCL_14    0x00000214
#define PORT_2_GCL_15    0x00000218

// define GCL address values Port 3
#define PORT_3_GCL_CTRL  0x0000021C
#define PORT_3_GCL_0     0x00000220
#define PORT_3_GCL_1     0x00000224
#define PORT_3_GCL_2     0x00000228
#define PORT_3_GCL_3     0x0000022C
#define PORT_3_GCL_4     0x00000230
#define PORT_3_GCL_5     0x00000234
#define PORT_3_GCL_6     0x00000238
#define PORT_3_GCL_7     0x0000023C
#define PORT_3_GCL_8     0x00000240
#define PORT_3_GCL_9     0x00000244
#define PORT_3_GCL_10    0x00000248
#define PORT_3_GCL_11    0x0000024C
#define PORT_3_GCL_12    0x00000250
#define PORT_3_GCL_13    0x00000254
#define PORT_3_GCL_14    0x00000258
#define PORT_3_GCL_15    0x0000025C

// define GCL time interval address values Port 0
#define PORT_0_GCL_TIME_0     0x000002A0
#define PORT_0_GCL_TIME_1     0x000002A4
#define PORT_0_GCL_TIME_2     0x000002A8
#define PORT_0_GCL_TIME_3     0x000002AC
#define PORT_0_GCL_TIME_4     0x000002B0
#define PORT_0_GCL_TIME_5     0x000002B4
#define PORT_0_GCL_TIME_6     0x000002B8
#define PORT_0_GCL_TIME_7     0x000002BC
#define PORT_0_GCL_TIME_8     0x000002C0
#define PORT_0_GCL_TIME_9     0x000002C4
#define PORT_0_GCL_TIME_10    0x000002C8
#define PORT_0_GCL_TIME_11    0x000002CC
#define PORT_0_GCL_TIME_12    0x000002D0
#define PORT_0_GCL_TIME_13    0x000002D4
#define PORT_0_GCL_TIME_14    0x000002D8
#define PORT_0_GCL_TIME_15    0x000002DC

// define GCL time interval address values Port 1
#define PORT_1_GCL_TIME_0     0x000002E0
#define PORT_1_GCL_TIME_1     0x000002E4
#define PORT_1_GCL_TIME_2     0x000002E8
#define PORT_1_GCL_TIME_3     0x000002EC
#define PORT_1_GCL_TIME_4     0x000002F0
#define PORT_1_GCL_TIME_5     0x000002F4
#define PORT_1_GCL_TIME_6     0x000002F8
#define PORT_1_GCL_TIME_7     0x000002FC
#define PORT_1_GCL_TIME_8     0x00000300
#define PORT_1_GCL_TIME_9     0x00000304
#define PORT_1_GCL_TIME_10    0x00000308
#define PORT_1_GCL_TIME_11    0x0000030C
#define PORT_1_GCL_TIME_12    0x00000310
#define PORT_1_GCL_TIME_13    0x00000314
#define PORT_1_GCL_TIME_14    0x00000318
#define PORT_1_GCL_TIME_15    0x0000031C

// define GCL time interval address values Port 2
#define PORT_2_GCL_TIME_0     0x00000320
#define PORT_2_GCL_TIME_1     0x00000324
#define PORT_2_GCL_TIME_2     0x00000328
#define PORT_2_GCL_TIME_3     0x0000032C
#define PORT_2_GCL_TIME_4     0x00000330
#define PORT_2_GCL_TIME_5     0x00000334
#define PORT_2_GCL_TIME_6     0x00000338
#define PORT_2_GCL_TIME_7     0x0000033C
#define PORT_2_GCL_TIME_8     0x00000340
#define PORT_2_GCL_TIME_9     0x00000344
#define PORT_2_GCL_TIME_10    0x00000348
#define PORT_2_GCL_TIME_11    0x0000034C
#define PORT_2_GCL_TIME_12    0x00000350
#define PORT_2_GCL_TIME_13    0x00000354
#define PORT_2_GCL_TIME_14    0x00000358
#define PORT_2_GCL_TIME_15    0x0000035C

// define GCL time interval address values Port 3
#define PORT_3_GCL_TIME_0     0x00000360
#define PORT_3_GCL_TIME_1     0x00000364
#define PORT_3_GCL_TIME_2     0x00000368
#define PORT_3_GCL_TIME_3     0x0000036C
#define PORT_3_GCL_TIME_4     0x00000370
#define PORT_3_GCL_TIME_5     0x00000374
#define PORT_3_GCL_TIME_6     0x00000378
#define PORT_3_GCL_TIME_7     0x0000037C
#define PORT_3_GCL_TIME_8     0x00000380
#define PORT_3_GCL_TIME_9     0x00000384
#define PORT_3_GCL_TIME_10    0x00000388
#define PORT_3_GCL_TIME_11    0x0000038C
#define PORT_3_GCL_TIME_12    0x00000390
#define PORT_3_GCL_TIME_13    0x00000394
#define PORT_3_GCL_TIME_14    0x00000398
#define PORT_3_GCL_TIME_15    0x0000039C

// define GCL control values
#define GCL_SET_CTRL_0 	    0x00
#define GCL_SET_RST         0x02
#define GCL_SET_TIME_RST    0x04

extern void *base_ptr_gcl;
int gcl_init(void *ptr);
int get_gcl(uint16_t portNumber);
int set_gcl(uint16_t portNumber, uint16_t gcl_id, uint16_t value);
int get_gcl_time_interval(uint16_t portNumber);
int set_gcl_time_interval(uint16_t portNumber, uint16_t gcl_id, uint16_t value);
#ifdef __cplusplus
}
#endif
#endif
