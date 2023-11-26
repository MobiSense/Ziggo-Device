/*
 * @Date: 2021-12-12 04:24:10
 * @LastEditors: Jiahang Wu
 * @LastEditTime: 2021-12-12 22:55:22
 * @FilePath: /linux_uio_app/tagger.c
 * @Description: 
 */

#include "tagger.h"

/**
 * @description: This function is used to init tagger module. Each port disable its tagger and untagger ability, proiority is set 0 by default.
 * @param {void} *ptr uio base ptr.
 * @return {*} 0 by default.
 */
int tagger_init(void *ptr) {
    base_ptr_tagger = ptr;
    *((unsigned *)(base_ptr_tagger + PORT_0_TAGGER))      = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = SET_TAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_0_UNTAGGER))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = SET_UNTAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_0_PRIORITY))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_0_TAGGER_CTRL)) = SET_PRIORITY;

    *((unsigned *)(base_ptr_tagger + PORT_1_TAGGER))      = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = SET_TAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_1_UNTAGGER))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = SET_UNTAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_1_PRIORITY))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_1_TAGGER_CTRL)) = SET_PRIORITY;

    *((unsigned *)(base_ptr_tagger + PORT_2_TAGGER))      = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = SET_TAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_2_UNTAGGER))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = SET_UNTAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_2_PRIORITY))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_2_TAGGER_CTRL)) = SET_PRIORITY;

    *((unsigned *)(base_ptr_tagger + PORT_3_TAGGER))      = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = SET_TAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_3_UNTAGGER))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = SET_UNTAGGER;
	*((unsigned *)(base_ptr_tagger + PORT_3_PRIORITY))    = TAGGER_VALUE_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(base_ptr_tagger + PORT_3_TAGGER_CTRL)) = SET_PRIORITY;
    return 0;
}

/**
 * @description: This function is used to set port's tagger's value. It is designed for enable_tagger() or disable_tagger().
 * @param {uint16_t} portNumber port's number, start from 0.
 * @param {int} value 0-disable, 1-enable
 * @return {*} 1 by default.
 */
int set_tagger(uint16_t portNumber, int value) {
    UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
    *((unsigned *)(TAGGER_ADDR)) = value;
    *((unsigned *)(CTRL_ADDR)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(CTRL_ADDR)) = SET_TAGGER;
    return 1;
}

/**
 * @description: This function is used to set port's untagger's value. It is designed for enable_untagger() or disable_untagger().
 * @param {uint16_t} portNumber port's number, start from 0.
 * @param {int} value 0-disable, 1-enable
 * @return {*} 1 by default.
 */
int set_untagger(uint16_t portNumber, int value) {
    UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
    *((unsigned *)(UNTAGGER_ADDR)) = value;
    *((unsigned *)(CTRL_ADDR)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(CTRL_ADDR)) = SET_UNTAGGER;
    return 1;
}

/**
 * @description: This function is used to enable port's tagger ability.
 * @param {uint16_t} portNumber port's number
 * @return {*} 1 by default.
 */
int enable_tagger(uint16_t portNumber) {
    set_tagger(portNumber, 1);
    return 1;
}

/**
 * @description: This function is used to disable port's tagger ability.
 * @param {uint16_t} portNumber port's number
 * @return {*} 1 by default.
 */
int disable_tagger(uint16_t portNumber) {
    set_tagger(portNumber, 0);
    return 1;
}

/**
 * @description: This function is used to disable port's tagger ability.
 * @param {uint16_t} portNumber port's number
 * @return {*} 1 by default.
 */
int enable_untagger(uint16_t portNumber) {
    set_untagger(portNumber, 1);
    return 1;
}

/**
 * @description: This function is used to disable port's untagger ability.
 * @param {uint16_t} portNumber port's number
 * @return {*} 1 by default.
 */
int disable_untagger(uint16_t portNumber) {
    set_untagger(portNumber, 0);
    return 1;
}

/**
 * @description: This function is used to check each port's tagger status.
 * @param {uint16_t} portNumber port's number
 * @return {int} 0-disabled, 1-enabled.
 */
int check_tagger_status(uint16_t portNumber) {
	UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
	int value;
	value = *((unsigned *)(TAGGER_ADDR));
	return value;
}

/**
 * @description: This function is used to check each port's untagger status.
 * @param {uint16_t} portNumber port's number
 * @return {int} 0-disabled, 1-enabled.
 */
int check_untagger_status(uint16_t portNumber) {
	UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
			UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
			PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
	int value;
	value = *((unsigned *)(UNTAGGER_ADDR));
	return value;
}

/**
 * @description: This function is used to set port's priority in VLAN header.
 * @param {uint16_t} portNumber port's number.
 * @param {uint16_t} priority priority to be set.
 * @return {int} 1 by default.
 */
int set_priority(uint16_t portNumber, uint16_t priority) {
    UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
    *((unsigned *)(PRIORITY_ADDR)) = priority;
    *((unsigned *)(CTRL_ADDR)) = TAGGER_SET_CTRL_0;
	*((unsigned *)(CTRL_ADDR)) = SET_PRIORITY;
    return 1;
}

/**
 * @description: This function is used to get port's priority in VLAN header.
 * @param {uint16_t} portNumber port's number.
 * @return {int} value of priority.
 */
int get_priority(uint16_t portNumber) {
    UINTPTR CTRL_ADDR;
	int* TAGGER_ADDR, UNTAGGER_ADDR, PRIORITY_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR     = base_ptr_tagger + PORT_0_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_0_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_0_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_0_PRIORITY;
			break;
		case 2:
			CTRL_ADDR     = base_ptr_tagger + PORT_1_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_1_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_1_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_1_PRIORITY;
			break;
		case 3:
			CTRL_ADDR     = base_ptr_tagger + PORT_2_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_2_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_2_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_2_PRIORITY;
			break;
		case 4:
			CTRL_ADDR     = base_ptr_tagger + PORT_3_TAGGER_CTRL;
			TAGGER_ADDR   = base_ptr_tagger + PORT_3_TAGGER;
            UNTAGGER_ADDR = base_ptr_tagger + PORT_3_UNTAGGER;
            PRIORITY_ADDR = base_ptr_tagger + PORT_3_PRIORITY;
			break;
		default:
			printf("set tagger: Invalid portNumber.\r\n");
			return 0;
	}
	uint16_t priority;
	priority = *((unsigned *)(PRIORITY_ADDR));

    return priority;
}

