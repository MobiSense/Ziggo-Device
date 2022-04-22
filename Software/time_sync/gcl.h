#ifndef GCL_H
#define GCL_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

#include "ptp_types.h"

void *base_ptr_gcl;
int gcl_init(void *ptr);
int get_gcl(uint16_t portNumber);
int set_gcl(uint16_t portNumber, uint16_t gcl_id, uint16_t value);
#endif
