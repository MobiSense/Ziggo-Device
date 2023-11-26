#include "pkt_gen.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*
* Description for registers: (32 byte for one register)
*   {reg1, reg0}: global period in ns for pkt_gen_controller.
*   {reg3, reg2}: global offset (based on rtc) for pkt_gen_controller.
*   reg4: valid signal, i bit for sequence i 
*   reg5: enable_vlan signal, i bit for sequence i
*   reg6: its bit 0 is used as global write lock. Set to 0 before update data, and 1 after update
*
*   for sequence i (i \in [0, 32)):
*       pkt_hdr[i] = { reg9*i+10,  reg9*i+9,  reg9*i+8,  reg9*i+7 };
*       seq_id[i] =  reg9*i+11[15:0];
*       pkt_number_sent[i] =  reg9*i+11[31:16];
*       pkt_id_start[i] =  reg9*i+12;
*       pkt_id_update[i] =  reg9*i+13;
*       tx_offset[i] = { reg9*i+15,  reg9*i+14 };
*/

// define global register address
#define GLOBAL_PERIOD_NS    0x00000000
#define GLOBAL_OFFSET_NS    0x00000008
#define SEQ_VALID           0x00000010
#define SEQ_ENABLE_VLAN     0x00000014
#define WRITE_LOCK          0x00000018

// define write lock value
#define NOT_WRITING     0x00000001
#define WRITING         0x00000000

// define address pointer for sequences
#define SEQ_CONTENT     0x0000001c
sequence_content *seq_ptr;

// define structure to store critical frame information
#define MAX_SEQ_NUM     65536
#define SEQ_REPORT_NUM 1000
char *file_name = "critical_log.csv";
FILE *fp;
critical_seq_log *critical_log;

char *file_pkt_name = "packet_log.csv";
FILE *fp_pkt = 0;

#define MAX(x, y) (((x) > (y)) ? (x) : (y))
#define MIN(x, y) (((x) < (y)) ? (x) : (y))

uint16_t swapByteOrder16 (uint16_t value) {
	uint16_t byte0 = value & 0x00FF;
    uint16_t byte1 = value & 0xFF00;
    return (byte1 >> 8) | (byte0 << 8);
}

uint32_t swapByteOrder(uint32_t value) {
#if defined(__llvm__) || (defined(__GNUC__) && !defined(__ICC))
  return __builtin_bswap32(value);
#elif defined(_MSC_VER) && !defined(_DEBUG)
  return _byteswap_ulong(value);
#else
  uint32_t byte0 = value & 0x000000FF;
  uint32_t byte1 = value & 0x0000FF00;
  uint32_t byte2 = value & 0x00FF0000;
  uint32_t byte3 = value & 0xFF000000;
  return (byte0 << 24) | (byte1 << 8) | (byte2 >> 8) | (byte3 >> 24);
#endif
}

uint64_t swapByteOrder64(uint64_t value) {
#if defined(__llvm__) || (defined(__GNUC__) && !defined(__ICC))
  return __builtin_bswap64(value);
#elif defined(_MSC_VER) && !defined(_DEBUG)
  return _byteswap_uint64(value);
#else
  uint64_t hi = swapByteOrder(uint32_t(value));
  uint32_t lo = swapByteOrder(uint32_t(value >> 32));
  return (hi << 32) | lo;
#endif
}


int is_critical_frame (uint8_t * buf_ptr) {
    ethernet_packet_vlan *packet = (ethernet_packet_vlan *) buf_ptr;
    // printf("0x%02x\n", swapByteOrder16(packet->ether_type));
    return swapByteOrder16(packet->ether_type) == CRITICAL_FRAME_ETHER_TYPE;
}

int64_t calc_mean (int64_t *array, int num) {
    int64_t sum = 0;
    for (int i = 0; i<num; i++) {
        sum += array[i];
    }
    return sum / num;
}

int64_t calc_var (int64_t *array, int num) {
    int64_t mean = calc_mean (array, num);
    int64_t sum = 0;
    for (int i = 0; i<num; i++) {
        sum += (array[i] - mean) * (array[i] - mean);
    }
    return sum / num;
}

void process_critical_frame (uint8_t *buf) {
    // init log structure
    if (!critical_log) {
        critical_log = (critical_seq_log *) malloc(MAX_SEQ_NUM * sizeof(critical_seq_log));
        memset(critical_log, 0, MAX_SEQ_NUM * sizeof(critical_seq_log));
        fp = fopen(file_name, "a");
        if (!fp) {
            printf ("*** Error: Cannot open file %s\n\n", file_name);
        } else {
            fprintf (fp, "Seq ID, Received Number, Max pkt_id, Min pkt_id, Loss Rate, Latency Mean, Latency Variance\r\n");
            fflush (fp);
        }
    }

    if (!fp_pkt) {
        fp_pkt = fopen(file_pkt_name, "a");
        if (!fp_pkt) {
            printf ("*** Error: Cannot open file %s\n\n", file_name);
        } else {
            fprintf (fp_pkt, "Seq ID, Pkt ID, TX timestamp, RX timestamp, Latency\r\n");
            fflush (fp_pkt);
        }
    }

    // parse critical frame
    ethernet_packet_vlan *packet = (ethernet_packet_vlan *) buf;
    uint16_t seq_id = swapByteOrder16(packet->seq_id);
    uint32_t pkt_id = swapByteOrder(packet->pkt_id);
    uint64_t tx_ts  = swapByteOrder64(packet->tx_timestamp);
    uint64_t rx_ts  = swapByteOrder64(packet->rx_timestamp);

    // print packet-wise information for detailed analysis
    fprintf (fp_pkt, "%04X, %u, %lld, %lld, %lld\r\n",
                    seq_id, pkt_id, tx_ts, rx_ts, (int64_t)rx_ts - (int64_t)tx_ts);

    // init sequence slot inside log structure
    if (!critical_log[seq_id].latency_list) {
        critical_log[seq_id].latency_list = (int64_t *) malloc ((SEQ_REPORT_NUM+5) * sizeof(int64_t));
        memset(critical_log[seq_id].latency_list, 0, (SEQ_REPORT_NUM+5) * sizeof(int64_t));
    }
    // update sequence slot's info
    critical_log[seq_id].cur_pkt_id = pkt_id;
    if (critical_log[seq_id].num_pkt_recvd == 0) {
        critical_log[seq_id].min_pkt_id = pkt_id;
        critical_log[seq_id].max_pkt_id = pkt_id;
    } else {
        critical_log[seq_id].min_pkt_id = MIN(pkt_id, critical_log[seq_id].min_pkt_id);
        critical_log[seq_id].max_pkt_id = MAX(pkt_id, critical_log[seq_id].max_pkt_id);
    }
    critical_log[seq_id].latency_list[critical_log[seq_id].num_pkt_recvd] = (int64_t)rx_ts - (int64_t)tx_ts;
    critical_log[seq_id].num_pkt_recvd++;

    // print statistic information
    if (critical_log[seq_id].num_pkt_recvd == 1) {
        print_critical_frame(buf);
    }
    else if (critical_log[seq_id].max_pkt_id - critical_log[seq_id].min_pkt_id >= SEQ_REPORT_NUM-1
            || critical_log[seq_id].num_pkt_recvd >= SEQ_REPORT_NUM) {
        // id range reaches SEQ_REPORT_NUM
        int64_t mean = calc_mean(critical_log[seq_id].latency_list, critical_log[seq_id].num_pkt_recvd);
        int64_t var = calc_var(critical_log[seq_id].latency_list, critical_log[seq_id].num_pkt_recvd);
        double drop_rate = 1-((double) critical_log[seq_id].num_pkt_recvd) / 
                (double) (critical_log[seq_id].max_pkt_id-critical_log[seq_id].min_pkt_id+1);
        printf ("\n------------- Critical FRAME SEQ INFO --------------\n");
        printf ("Sequence ID: 0x%04X\n", seq_id);
        printf ("Received packet number: %u\n", critical_log[seq_id].num_pkt_recvd);
        printf ("Minimum  packet ID    : %u\n", critical_log[seq_id].min_pkt_id);
        printf ("Maximum  packet ID    : %u\n", critical_log[seq_id].max_pkt_id);
        printf ("Packet loss rate      : %lf\n", drop_rate);
        printf ("Average transmission latency   : %lld ns\n", mean);
        printf ("Variance of latency            : %lld\n", var);
        printf ("----------------------------------------------------\n");
        // export to csv file
        if (fp) {
            fprintf (fp, "%04X, %u, %u, %u, %lf,  %lld, %lld\r\n",
                    seq_id, critical_log[seq_id].num_pkt_recvd, critical_log[seq_id].min_pkt_id,
                    critical_log[seq_id].max_pkt_id, drop_rate, mean, var);
            fflush (fp);
        }
        // reset for the next SEQ_REPORT_NUM packets.
        critical_log[seq_id].num_pkt_recvd = 0;
    }
}

int print_critical_frame (uint8_t *buf_ptr) {
    if (!is_critical_frame(buf_ptr)) {
        printf ("ERROR ***: (function print_critical_frame) try to print a non critical frame!\n");
        return 1;
    }
    ethernet_packet_vlan *packet = (ethernet_packet_vlan *) buf_ptr;
    printf ("\n------------- Critical Frame INFO --------------\n");
    printf ("transmission timestamp: %llu\n", swapByteOrder64(packet->tx_timestamp));
    printf ("receiving    timestamp: %llu\n", swapByteOrder64(packet->rx_timestamp));
    printf ("sequence ID: %u\n", swapByteOrder16(packet->seq_id));
    printf ("packet   ID: %u\n", swapByteOrder(packet->pkt_id));
    printf ("------------------------------------------------\n");
    return 0;
}


int pkt_gen_init() {
    void *base_ptr;
    int fd;

    // TODO: verify device name before open (cat /sys/class/uio/uio0/name)
	char *uiod = "/dev/uio0";
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

    base_ptr_pkt_gen = base_ptr;

    /* initialize registers */
    *((unsigned *)(base_ptr_pkt_gen+WRITE_LOCK)) = NOT_WRITING;
    *((unsigned *)(base_ptr_pkt_gen+SEQ_VALID))  = 0;
    seq_ptr = (sequence_content *)(base_ptr_pkt_gen+SEQ_CONTENT);

    return 0;
}

int start_pkt_gen_config(uint64_t global_period_ns) {
    printf ("Start updating schedule table for packet generation.\n");

    /* Start updating sequence table */
    *((unsigned *)(base_ptr_pkt_gen+WRITE_LOCK)) = WRITING;
    *((unsigned *)(base_ptr_pkt_gen+SEQ_VALID))  = 0;

    // setup global period & offset
    *(( uint64_t *)(base_ptr_pkt_gen+GLOBAL_OFFSET_NS)) = 0;
    *(( uint64_t *)(base_ptr_pkt_gen+GLOBAL_PERIOD_NS)) = global_period_ns; // actual period is 2^(PERIOD)
}

int finish_pkt_gen_config() {
    /* Finish updating */

    *((unsigned *)(base_ptr_pkt_gen+WRITE_LOCK)) = NOT_WRITING;
    
    printf ("Finish updating schedule table for packet generation.\n");
}

int set_pkt_gen_slot (int slot_id, uint16_t seq_id, uint16_t pkt_number, uint32_t pkt_id_start, 
        uint32_t pkt_id_update, int64_t tx_offset, uint8_t *src_mac, uint8_t *dest_mac) {
    // initialize mac address
    #ifndef ETHER_ADDR_LEN
    #define ETHER_ADDR_LEN 6
    #endif
    uint8_t *mac_addr = (uint8_t *) malloc (ETHER_ADDR_LEN * 2);
    memcpy (mac_addr, dest_mac, ETHER_ADDR_LEN);
    memcpy (mac_addr + ETHER_ADDR_LEN, src_mac, ETHER_ADDR_LEN);

    // bit operation adapt from: https://stackoverflow.com/questions/47981/how-do-you-set-clear-and-toggle-a-single-bit
    *((unsigned *)(base_ptr_pkt_gen+SEQ_VALID)) |= 1UL<<slot_id; // valid sequence
    *((unsigned *)(base_ptr_pkt_gen+SEQ_ENABLE_VLAN)) |= 1UL<<slot_id; // enable vlan
    memcpy (seq_ptr[slot_id].hdr.ether_dhost, mac_addr, ETHER_ADDR_LEN*2); // must be 12 byte copy
    seq_ptr[slot_id].hdr.TPID = 0x0081; // 0x8100 acctually, need to be reversed
    seq_ptr[slot_id].hdr.vlan_header = 0x0020; // 0x2002 acctually, need to be reversed
    seq_ptr[slot_id].seq_id = seq_id; // this is irrelevant to current sequence's index
    seq_ptr[slot_id].pkt_number_sent = pkt_number;
    seq_ptr[slot_id].pkt_id_start = pkt_id_start;
    seq_ptr[slot_id].pkt_id_update = pkt_id_update;
    seq_ptr[slot_id].tx_offset = tx_offset;
}


// Tutorial for how to use pkt_gen_app
// Ideally, this test application should let the axi_pkt_gen module works similar to it in simulation.
int pkt_gen_test() {
    pkt_gen_init();
    
    start_pkt_gen_config(25);

    // in order to get word alignment, this two MAC address should be assigned together
    uint8_t src_mac[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x02};
    uint8_t dest_mac_a[] = {0x06, 0x05, 0x04, 0x03, 0x02, 0x01};
    uint8_t dest_mac_b[] = {0x01, 0x03, 0x05, 0x07, 0x09, 0x11};


    // setup slot 0 content
    set_pkt_gen_slot (0, 1, 10, 0, 20, 0, src_mac, dest_mac_a);
    
    // setup slot 1 content
    set_pkt_gen_slot (1, 3, 20, 0, 20, 1<<22, src_mac, dest_mac_b);
    
    // setup slot 2 content
    set_pkt_gen_slot (2, 1, 10, 10, 20, 1<<24, src_mac, dest_mac_a);

    finish_pkt_gen_config();
}
