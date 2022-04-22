#ifndef UIO_H
#define UIO_H
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>

/* Init UIO device and return base_ptr address */
void *uio_init();

#endif