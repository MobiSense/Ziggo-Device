/*
 * @Date: 2021-12-21 15:15:03
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-21 15:17:30
 * @FilePath: \gpio_driver\gpio_reset.cpp
 * @Description: This file is used to reset PL by GPIO EMIO.
 *  In Zynq-7000, there are 54 MIO pins to control PS and 64 EMIO pins to
 * control PL. Here we set EMIO width to 1, so that we can use one EMIO pin to
 * control the aux_reset_in of the Processor System Reset Module. The
 * aux_reset_in is set to [Active-High], so when we set GPIO output to 1, the
 * aux_reset_in will be active. Then the output of Processor System Reset module
 * - peripheral_aresetn, will be active, and then activate all PL reset signals
 * in Block Design. Also, the s_axi_time_sync_aresetn will be reset.
 */
#include "gpio_reset.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/**
 * @description: This function is used to reset PL by GPIO EMIO.
 * @param {char*} emio_id
 *      Run "ls /sys/class/gpio/", you will see a file named "gpiochio***", ***
 * is a number, the number means the start index of GPIO pins. First part of
 * GPIO is MIO pins, which has the size of 54, and EMIO pins are behind them. So
 * the EMIO are start from 54, so parameter emio_id should be  <*** + 54>.
 * @return {int}
 */
int reset_PL_by_GPIO(char *emio_id) {
    int valuefd;
    int exportfd;
    int directionfd;

    // export GPIO in sysfs
    exportfd = open("/sys/class/gpio/export", O_WRONLY);
    if (exportfd < 0) {
        printf("Cannot open GPIO to export it\n");
        exit(1);
    }
    write(exportfd, emio_id, 4);
    close(exportfd);

    // Update the direction of the GPIO to be an output
    char direction_file[100];
    strcpy(direction_file, "/sys/class/gpio/gpio");
    strcat(direction_file, emio_id);
    strcat(direction_file, "/direction");
    directionfd = open(direction_file, O_RDWR);
    if (directionfd < 0) {
        printf("Cannot open GPIO direction it\n");
        exit(1);
    }

    write(directionfd, "out", 4);
    close(directionfd);
    printf("GPIO direction set as output successfully\n");

    // Get the GPIO value ready to be toggled
    char value_file[100];
    strcpy(value_file, "/sys/class/gpio/gpio");
    strcat(value_file, emio_id);
    strcat(value_file, "/value");
    valuefd = open(value_file, O_RDWR);
    if (valuefd < 0) {
        printf("Cannot open GPIO value\n");
        exit(1);
    }
    printf("GPIO value opened, now toggling...\n");
    write(valuefd, "1", 2); // reset start
    sleep(1);
    write(valuefd, "0", 2); // reset finish

    return 0;
}
