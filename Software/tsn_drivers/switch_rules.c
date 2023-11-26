/*
Rev 20220420
There are 6 default switch rules.
Previously, when execute switch_rule_init, all registers (rules) are cleared.
The rules connecting to PS Linux is also broken.
In this revision we always keep the six default switch rules.
*/

#include "switch_rules.h"

#include <stdio.h>

#define N_DEFAULT_RULE 6
#define SWITCH_TABLE_LEN 64

int g_counter;
void *g_base_ptr;

int switch_rule_init(void *ptr) {
    // Clear all existing switch rules except the default rules.
    // The switch rule for PTP frames are fixed in hardware, thus it will not be
    // affected.
    g_counter = N_DEFAULT_RULE * 2;  // one rule is described by two registers.
    g_base_ptr = ptr;
    unsigned int *reg_base_ptr = g_base_ptr;
    for (int i = N_DEFAULT_RULE * 2; i < SWITCH_TABLE_LEN; i++) {
        *((unsigned *)(reg_base_ptr + i)) = 0;
    }
    return 0;
}

int push_switch_rule(char *mac_addr, int output_port) {
    /*
        Push a switch rule to the rule table
        mac_addr: 6 byte destination mac address.
        output_port: 0 -> to Port 0
                    1 -> to Port 1
                    2 -> to Port 2
                    3 -> to Port 3
                    4 -> to PLC DMA
                    5 -> to PS ETH
        The switch rule for PTP frames are fixed in hardware, no need to specify
       explicitly.
    */
    char output_port_byte;
    if (output_port == 0) {
        output_port_byte = 0x01;
    } else if (output_port == 1) {
        output_port_byte = 0x04;
    } else if (output_port == 2) {
        output_port_byte = 0x10;
    } else if (output_port == 3) {
        output_port_byte = 0x40;
    } else if (output_port == 4) {
        output_port_byte = 0x08;
    } else if (output_port == 5) {
        output_port_byte = 0x20;
    } else {
        printf("Unknown output_port.\r\n");
        return 1;
    }
    unsigned int *reg_base_ptr = g_base_ptr;
    unsigned int *reg_ptr = reg_base_ptr + g_counter;
    char *reg_byte_ptr = reg_ptr;
    *(reg_byte_ptr) = mac_addr[2];
    *(reg_byte_ptr + 1) = mac_addr[3];
    *(reg_byte_ptr + 2) = mac_addr[4];
    *(reg_byte_ptr + 3) = mac_addr[5];
    *(reg_byte_ptr + 4) = output_port_byte;
    *(reg_byte_ptr + 5) = 0x0;  // This byte is not used.
    *(reg_byte_ptr + 6) = mac_addr[0];
    *(reg_byte_ptr + 7) = mac_addr[1];
    g_counter = g_counter + 2;  // each rule takes two registers.
    return 0;
}
