/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Xiaowu He, Jiahang Wu
 * @LastEditTime: 2021-12-12 20:20:05
 * @FilePath: /linux_uio_app/uio.h
 * @Description: 
 */
#ifndef UIO_H
#define UIO_H
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


/* Init UIO device and return base_ptr address */
void *switch_rule_uio_init();
void *uio_init(char *uiod);

#ifdef __cplusplus
}
#endif
#endif