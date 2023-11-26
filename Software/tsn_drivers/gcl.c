#include "gcl.h"

void *base_ptr_gcl;

/* define gcl value list in each port. */
int port_0_gcl[] = { 
	PORT_0_GCL_0 ,
    PORT_0_GCL_1 ,
    PORT_0_GCL_2 ,
    PORT_0_GCL_3 ,
    PORT_0_GCL_4 ,
    PORT_0_GCL_5 ,
    PORT_0_GCL_6 ,
    PORT_0_GCL_7 ,
    PORT_0_GCL_8 ,
    PORT_0_GCL_9 ,
    PORT_0_GCL_10,
    PORT_0_GCL_11,
    PORT_0_GCL_12,
    PORT_0_GCL_13,
    PORT_0_GCL_14,
    PORT_0_GCL_15 
};
int port_1_gcl[] = { 
	PORT_1_GCL_0 ,
    PORT_1_GCL_1 ,
    PORT_1_GCL_2 ,
    PORT_1_GCL_3 ,
    PORT_1_GCL_4 ,
    PORT_1_GCL_5 ,
    PORT_1_GCL_6 ,
    PORT_1_GCL_7 ,
    PORT_1_GCL_8 ,
    PORT_1_GCL_9 ,
    PORT_1_GCL_10,
    PORT_1_GCL_11,
    PORT_1_GCL_12,
    PORT_1_GCL_13,
    PORT_1_GCL_14,
    PORT_1_GCL_15 
};
int port_2_gcl[] = { 
	PORT_2_GCL_0 ,
    PORT_2_GCL_1 ,
    PORT_2_GCL_2 ,
    PORT_2_GCL_3 ,
    PORT_2_GCL_4 ,
    PORT_2_GCL_5 ,
    PORT_2_GCL_6 ,
    PORT_2_GCL_7 ,
    PORT_2_GCL_8 ,
    PORT_2_GCL_9 ,
    PORT_2_GCL_10,
    PORT_2_GCL_11,
    PORT_2_GCL_12,
    PORT_2_GCL_13,
    PORT_2_GCL_14,
    PORT_2_GCL_15 
};
int port_3_gcl[] = { 
	PORT_3_GCL_0 ,
    PORT_3_GCL_1 ,
    PORT_3_GCL_2 ,
    PORT_3_GCL_3 ,
    PORT_3_GCL_4 ,
    PORT_3_GCL_5 ,
    PORT_3_GCL_6 ,
    PORT_3_GCL_7 ,
    PORT_3_GCL_8 ,
    PORT_3_GCL_9 ,
    PORT_3_GCL_10,
    PORT_3_GCL_11,
    PORT_3_GCL_12,
    PORT_3_GCL_13,
    PORT_3_GCL_14,
    PORT_3_GCL_15 
};

/* define gcl time interval list in each port. */
int port_0_gcl_time[] = { 
	PORT_0_GCL_TIME_0 ,
    PORT_0_GCL_TIME_1 ,
    PORT_0_GCL_TIME_2 ,
    PORT_0_GCL_TIME_3 ,
    PORT_0_GCL_TIME_4 ,
    PORT_0_GCL_TIME_5 ,
    PORT_0_GCL_TIME_6 ,
    PORT_0_GCL_TIME_7 ,
    PORT_0_GCL_TIME_8 ,
    PORT_0_GCL_TIME_9 ,
    PORT_0_GCL_TIME_10,
    PORT_0_GCL_TIME_11,
    PORT_0_GCL_TIME_12,
    PORT_0_GCL_TIME_13,
    PORT_0_GCL_TIME_14,
    PORT_0_GCL_TIME_15 
};
int port_1_gcl_time[] = { 
	PORT_1_GCL_TIME_0 ,
    PORT_1_GCL_TIME_1 ,
    PORT_1_GCL_TIME_2 ,
    PORT_1_GCL_TIME_3 ,
    PORT_1_GCL_TIME_4 ,
    PORT_1_GCL_TIME_5 ,
    PORT_1_GCL_TIME_6 ,
    PORT_1_GCL_TIME_7 ,
    PORT_1_GCL_TIME_8 ,
    PORT_1_GCL_TIME_9 ,
    PORT_1_GCL_TIME_10,
    PORT_1_GCL_TIME_11,
    PORT_1_GCL_TIME_12,
    PORT_1_GCL_TIME_13,
    PORT_1_GCL_TIME_14,
    PORT_1_GCL_TIME_15 
};
int port_2_gcl_time[] = { 
	PORT_2_GCL_TIME_0 ,
    PORT_2_GCL_TIME_1 ,
    PORT_2_GCL_TIME_2 ,
    PORT_2_GCL_TIME_3 ,
    PORT_2_GCL_TIME_4 ,
    PORT_2_GCL_TIME_5 ,
    PORT_2_GCL_TIME_6 ,
    PORT_2_GCL_TIME_7 ,
    PORT_2_GCL_TIME_8 ,
    PORT_2_GCL_TIME_9 ,
    PORT_2_GCL_TIME_10,
    PORT_2_GCL_TIME_11,
    PORT_2_GCL_TIME_12,
    PORT_2_GCL_TIME_13,
    PORT_2_GCL_TIME_14,
    PORT_2_GCL_TIME_15 
};
int port_3_gcl_time[] = { 
	PORT_3_GCL_TIME_0 ,
    PORT_3_GCL_TIME_1 ,
    PORT_3_GCL_TIME_2 ,
    PORT_3_GCL_TIME_3 ,
    PORT_3_GCL_TIME_4 ,
    PORT_3_GCL_TIME_5 ,
    PORT_3_GCL_TIME_6 ,
    PORT_3_GCL_TIME_7 ,
    PORT_3_GCL_TIME_8 ,
    PORT_3_GCL_TIME_9 ,
    PORT_3_GCL_TIME_10,
    PORT_3_GCL_TIME_11,
    PORT_3_GCL_TIME_12,
    PORT_3_GCL_TIME_13,
    PORT_3_GCL_TIME_14,
    PORT_3_GCL_TIME_15 
};

/**
 * @description: This function is used to init gcl base pointer, init GCL value to 2, and init GCL time interval to 0x400.
 * @param {void} *ptr uio base pointer.
 * @return {*} 0 by default.
 *
 * reference: IEEE std 802.1Q 2018, page 198. priority 0 or no VLAN -> queue 1, priority 1 -> queue 0.
 */
int gcl_init(void *ptr) {
	base_ptr_gcl = ptr;

	for (int j = 0; j < 16; j++) {
		// Init GCL to 0
		*((unsigned *)(base_ptr_gcl + port_0_gcl[j])) = (j << 9) | 2;
		*((unsigned *)(base_ptr_gcl + PORT_0_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_0_GCL_CTRL)) = GCL_SET_RST;

		*((unsigned *)(base_ptr_gcl + port_1_gcl[j])) = (j << 9) | 2;
		*((unsigned *)(base_ptr_gcl + PORT_1_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_1_GCL_CTRL)) = GCL_SET_RST;

		*((unsigned *)(base_ptr_gcl + port_2_gcl[j])) = (j << 9) | 2;
		*((unsigned *)(base_ptr_gcl + PORT_2_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_2_GCL_CTRL)) = GCL_SET_RST;

		*((unsigned *)(base_ptr_gcl + port_3_gcl[j])) = (j << 9) | 2;
		*((unsigned *)(base_ptr_gcl + PORT_3_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_3_GCL_CTRL)) = GCL_SET_RST;
		// Init GCL time interval to 0
		*((unsigned *)(base_ptr_gcl + port_0_gcl_time[j])) = (j << 20) | 0x400;
		*((unsigned *)(base_ptr_gcl + PORT_0_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_0_GCL_CTRL)) = GCL_SET_TIME_RST;

		*((unsigned *)(base_ptr_gcl + port_1_gcl_time[j])) = (j << 20) | 0x400;
		*((unsigned *)(base_ptr_gcl + PORT_1_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_1_GCL_CTRL)) = GCL_SET_TIME_RST;

		*((unsigned *)(base_ptr_gcl + port_2_gcl_time[j])) = (j << 20) | 0x400;
		*((unsigned *)(base_ptr_gcl + PORT_2_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_2_GCL_CTRL)) = GCL_SET_TIME_RST;

		*((unsigned *)(base_ptr_gcl + port_3_gcl_time[j])) = (j << 20) | 0x400;
		*((unsigned *)(base_ptr_gcl + PORT_3_GCL_CTRL)) = GCL_SET_CTRL_0;
		*((unsigned *)(base_ptr_gcl + PORT_3_GCL_CTRL)) = GCL_SET_TIME_RST;
	}

	return 0;
}

/**
 * @description: This function is used to get gcl values of the port [portNumber].
 * @param {uint16_t} portNumber port's number.
 * @return {*} 0 by default.
 */
int get_gcl(uint16_t portNumber) {
    UINTPTR CTRL_ADDR;
	int* GCL_DATA_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR = base_ptr_gcl + PORT_0_GCL_CTRL;
			GCL_DATA_ADDR = port_0_gcl;
			break;
		case 2:
			CTRL_ADDR = base_ptr_gcl + PORT_1_GCL_CTRL;
			GCL_DATA_ADDR = port_1_gcl;
			break;
		case 3:
			CTRL_ADDR = base_ptr_gcl + PORT_2_GCL_CTRL;
			GCL_DATA_ADDR = port_2_gcl;
			break;
		case 4:
			CTRL_ADDR = base_ptr_gcl + PORT_3_GCL_CTRL;
			GCL_DATA_ADDR = port_3_gcl;
			break;
		default:
			printf("get gcl: Invalid portNumber.\r\n");
			return 0;
	}
	unsigned int gcl_data;
	for (int i = 0; i < 16; i++) {
        gcl_data = *((unsigned*)(base_ptr_gcl + GCL_DATA_ADDR[i]));
		printf("GCL[%d]: %08X\r\n", i, gcl_data);
	}
	return 0;
}

/**
 * @description: This function is used to set GCL's value, set port [portNumber] 's GCL[gcl_id] to [value].
 * @param {uint16_t} portNumber port number, start from 0.
 * @param {uint16_t} gcl_id GCL index.
 * @param {uint16_t} value the GCL value to set.
 * @return {*} 0 by default.
 */
int set_gcl(uint16_t portNumber, uint16_t gcl_id, uint16_t value) {
	UINTPTR CTRL_ADDR;
	int* GCL_DATA_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR = base_ptr_gcl + PORT_0_GCL_CTRL;
			GCL_DATA_ADDR = port_0_gcl;
			break;
		case 2:
			CTRL_ADDR = base_ptr_gcl + PORT_1_GCL_CTRL;
			GCL_DATA_ADDR = port_1_gcl;
			break;
		case 3:
			CTRL_ADDR = base_ptr_gcl + PORT_2_GCL_CTRL;
			GCL_DATA_ADDR = port_2_gcl;
			break;
		case 4:
			CTRL_ADDR = base_ptr_gcl + PORT_3_GCL_CTRL;
			GCL_DATA_ADDR = port_3_gcl;
			break;
		default:
			printf("set gcl: Invalid portNumber.\r\n");
			return 0;
	}
	*((unsigned *)(base_ptr_gcl + GCL_DATA_ADDR[gcl_id])) = (gcl_id << 9) + value;

    // printf("Set Port[%d] GCL[%d]: %08X\r\n", portNumber, gcl_id, *((unsigned *)(base_ptr_gcl + GCL_DATA_ADDR[gcl_id])));
	*((unsigned *)(CTRL_ADDR)) = GCL_SET_CTRL_0;
	*((unsigned *)(CTRL_ADDR)) = GCL_SET_RST;
	return 0;
}

/**
 * @description: This function is used to get all GCL time intervals of port [portNumber]. Consider we get time interval is x, the real time interval is (x * 2^8 * 8) nanoseconds.
 * @param {uint16_t} portNumber port number, start from 0.
 * @return {*} 0 by default.
 */
int get_gcl_time_interval(uint16_t portNumber)
{
	UINTPTR CTRL_ADDR;
	int* GCL_TIME_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR = base_ptr_gcl + PORT_0_GCL_CTRL;
			GCL_TIME_ADDR = port_0_gcl;
			break;
		case 2:
			CTRL_ADDR = base_ptr_gcl + PORT_1_GCL_CTRL;
			GCL_TIME_ADDR = port_1_gcl;
			break;
		case 3:
			CTRL_ADDR = base_ptr_gcl + PORT_2_GCL_CTRL;
			GCL_TIME_ADDR = port_2_gcl;
			break;
		case 4:
			CTRL_ADDR = base_ptr_gcl + PORT_3_GCL_CTRL;
			GCL_TIME_ADDR = port_3_gcl;
			break;
		default:
			printf("get gcl: Invalid portNumber.\r\n");
			return 0;
	}
	unsigned int gcl_time;
	for (int i = 0; i < 16; i++) {
        gcl_time = *((unsigned*)(base_ptr_gcl + GCL_TIME_ADDR[i]));
		printf("GCL time interval[%d]: %08X\r\n", i, gcl_time);
	}
	return 0;

}

/**
 * @description: This function is used to set GCL's time interval, set port [portNumber] 's GCL time interval[gcl_id] to [value].
 * @param {uint16_t} portNumber port number, start from 0.
 * @param {uint16_t} gcl_id GCL index.
 * @param {uint16_t} value the GCL time interval x to set. The real time interval is (x * 2^8 * 8) nanoseconds.
 * @return {*} 0 by default.
 */
int set_gcl_time_interval(uint16_t portNumber, uint16_t gcl_id, uint16_t value)
{
	UINTPTR CTRL_ADDR;
	int* GCL_TIME_ADDR;
	switch (portNumber)
	{
		case 1:
			CTRL_ADDR = base_ptr_gcl + PORT_0_GCL_CTRL;
			GCL_TIME_ADDR = port_0_gcl_time;
			break;
		case 2:
			CTRL_ADDR = base_ptr_gcl + PORT_1_GCL_CTRL;
			GCL_TIME_ADDR = port_1_gcl_time;
			break;
		case 3:
			CTRL_ADDR = base_ptr_gcl + PORT_2_GCL_CTRL;
			GCL_TIME_ADDR = port_2_gcl_time;
			break;
		case 4:
			CTRL_ADDR = base_ptr_gcl + PORT_3_GCL_CTRL;
			GCL_TIME_ADDR = port_3_gcl_time;
			break;
		default:
			printf("set gcl time interval: Invalid portNumber.\r\n");
			return 0;
	}
	*((unsigned *)(base_ptr_gcl + GCL_TIME_ADDR[gcl_id])) = (gcl_id << 20) + value;

    printf("Set Port[%d] GCL time interval[%d]: %08X\r\n", portNumber, gcl_id, *((unsigned *)(base_ptr_gcl + GCL_TIME_ADDR[gcl_id])));
	*((unsigned *)(CTRL_ADDR)) = GCL_SET_CTRL_0;
	*((unsigned *)(CTRL_ADDR)) = GCL_SET_TIME_RST;
	return 0;
}
