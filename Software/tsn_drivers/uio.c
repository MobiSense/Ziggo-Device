/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Xiaowu He, Jiahang Wu
 * @LastEditTime: 2021-12-12 20:19:40
 * @FilePath: /linux_uio_app/uio.c
 * @Description: 
 */

#include "uio.h"

/**
 * @description: This function is used to init uio device.
 * @param {char} *uiod UIO device file, "/dev/uio0" for example.
 * @return {*} base pointer of uio device.
 */
void *uio_init(char *uiod) {
    void *base_ptr;
    int fd;
    /* Open the UIO device file */
    fd = open(uiod, O_RDWR);
    if (fd < 1) {
    	printf("Invalid UIO device file:%s!\n", uiod);
    	return -1;
    }
    printf("(fd:%d) UIO device file:%s is valid.\n", fd, uiod);

    /* mmap the UIO device */
    base_ptr = mmap(NULL, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    if(base_ptr == MAP_FAILED){
    	perror("mmap() failed\n");
        return 1;
    }
    printf("mmap() success!\n");
    printf("uio base_ptr is: %p\n", base_ptr);

    return base_ptr;
}

void *switch_rule_uio_init() {
    void *base_ptr;
    int fd;
	char *uiod = "/dev/uio1";
    /* Open the UIO device file */
    fd = open(uiod, O_RDWR);
    if (fd < 1) {
    	printf("Invalid UIO device file:%s!\n", uiod);
    	return -1;
    }
    printf("(fd:%d) UIO device file:%s is valid.\n", fd, uiod);

    /* mmap the UIO device */
    base_ptr = mmap(NULL, 65536, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    if(base_ptr == MAP_FAILED){
    	perror("mmap() failed\n");
        return 1;
    }
    printf("mmap() success!\n");
    printf("base_ptr: %p\n", base_ptr);

    return base_ptr;
}
