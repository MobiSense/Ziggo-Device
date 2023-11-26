#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>
#include <signal.h>
#include <sched.h>
#include <time.h>
#include <errno.h>
#include <sys/param.h>
#include <pthread.h>

#include "dma-proxy.h"
#include "../log/log.h"
#include "../pkt_gen_control/pkt_gen.h"

/* The user must tune the application number of channels to match the proxy driver device tree
 * and the names of each channel must match the dma-names in the device tree for the proxy
 * driver node. The number of channels can be less than the number of names as the other
 * channels will just not be used in testing.
 */
#define TX_CHANNEL_COUNT 1
#define RX_CHANNEL_COUNT 1
#define MAX_PKT_LEN		    1600

const char *tx_channel_names[] = { "dma_proxy_tx", /* add unique channel names here */ };
const char *rx_channel_names[] = { "dma_proxy_rx", /* add unique channel names here */ };

struct channel {
	struct channel_buffer *buf_ptr;    // pointer to buffer
	int fd;                            // file descriptor
};

struct channel tx_channels[TX_CHANNEL_COUNT], rx_channels[RX_CHANNEL_COUNT];

// ---------------------------------------------------------------------

int axi_dma_init() {
    /* Open the file descriptors for each tx channel and map the kernel driver memory into user space */
    int i;
	for (i = 0; i < TX_CHANNEL_COUNT; i++) {
		char channel_name[64] = "/dev/";
		strcat(channel_name, tx_channel_names[i]);
		tx_channels[i].fd = open(channel_name, O_RDWR);
		if (tx_channels[i].fd < 1) {
			printf("Unable to open DMA proxy device file: %s\r", channel_name);
			exit(EXIT_FAILURE);
		}
		tx_channels[i].buf_ptr = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer) * TX_BUFFER_COUNT,
										PROT_READ | PROT_WRITE, MAP_SHARED, tx_channels[i].fd, 0);
		if (tx_channels[i].buf_ptr == MAP_FAILED) {
			printf("Failed to mmap tx channel\n");
			exit(EXIT_FAILURE);
		}
	}

	/* Open the file descriptors for each rx channel and map the kernel driver memory into user space */
	for (i = 0; i < RX_CHANNEL_COUNT; i++) {
		char channel_name[64] = "/dev/";
		strcat(channel_name, rx_channel_names[i]);
		rx_channels[i].fd = open(channel_name, O_RDWR);
		if (rx_channels[i].fd < 1) {
			printf("Unable to open DMA proxy device file: %s\r", channel_name);
			exit(EXIT_FAILURE);
		}
		rx_channels[i].buf_ptr = (struct channel_buffer *)mmap(NULL, sizeof(struct channel_buffer) * RX_BUFFER_COUNT,
										PROT_READ | PROT_WRITE, MAP_SHARED, rx_channels[i].fd, 0);
		if (rx_channels[i].buf_ptr == MAP_FAILED) {
			printf("Failed to mmap rx channel\n");
			exit(EXIT_FAILURE);
		}
	}

    log_info ("Successfully initiate DMA.");

    return 1;
}

void DMA_send (uint8_t *buffer, int length) {
    int buffer_id = 0; 
    memcpy(tx_channels[0].buf_ptr[buffer_id].buffer, buffer, length);
    tx_channels[0].buf_ptr[buffer_id].length = length;
    ioctl(tx_channels[0].fd, XFER, &buffer_id);

    if (tx_channels[0].buf_ptr[buffer_id].status != PROXY_NO_ERROR) {
        log_error("DMA send frame fail.\r\n");
        exit(EXIT_FAILURE);
	}
}

/* return true if this frame is ptp frame */
int is_ptp_frame(uint8_t *buffer_ptr) {
    static uint8_t mac_addr_ptp[] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e};
    if (memcmp(mac_addr_ptp, buffer_ptr, 6) == 0) {
    	// printf ("This is a ptp frame!\n");
        return 1;
    } else {
    	// printf ("This is NOT a ptp frame!\n");
        return 0;
    }
}

void process_packet(uint8_t *buf, buffer_queue *queue) {
	// printf ("Processing a packet: \r\n");
	// for (int i = 0; i < 32; i++)
	// 	printf("%02x", buf[i]);
	// printf("\n");
    if (is_ptp_frame(buf)) {
        // printf ("Push the PTP packet into buffer queue.\r\n");
        pthread_mutex_lock(&buf_queue_lock);
        // printf ("dma-proxy.c: Entering critical region for buffer_queue.\r\n");
        push_queue(queue, buf, MAX_PKT_LEN);
        pthread_mutex_unlock(&buf_queue_lock);
        // printf ("dma-proxy.c: Leaving critical region for buffer_queue.\r\n");
    }
    else if (is_critical_frame(buf)) {
        // print_critical_frame(buf);
		process_critical_frame(buf);
    }
}

// cite: https://github.com/Horacehxw/software-prototypes/blob/master/linux-user-space-dma/Software/User/dma-proxy-test.c
void *DMA_rx_thread (buffer_queue *queue) {
	log_info("Entering rx thread");
    struct channel *channel_ptr = rx_channels;
    int in_progress_count = 0, buffer_id = 0;
	int rx_counter = 0;

	// Start all buffers being received

	for (buffer_id = 0; buffer_id < RX_BUFFER_COUNT; buffer_id += BUFFER_INCREMENT) {

		/* Don't worry about initializing the receive buffers as the pattern used in the
		 * transmit buffers is unique across every transfer so it should catch errors.
		 */
		channel_ptr->buf_ptr[buffer_id].length = BUFFER_SIZE;

		ioctl(channel_ptr->fd, START_XFER, &buffer_id);

        in_progress_count++;
	}

	buffer_id = 0;

	/* Finish each queued up receive buffer and keep starting the buffer over again
	 * until all the transfers are done
	 */
	while (1) {

        // poll (waste CPU)
		ioctl(channel_ptr->fd, POLL_XFER, &buffer_id);

        // wait (may encounter error)
		// ioctl(channel_ptr->fd, FINISH_XFER, &buffer_id);

		if (channel_ptr->buf_ptr[buffer_id].status != PROXY_NO_ERROR) {
//			printf("Proxy rx transfer haven't finished, # RX completed %d, # in progress %d\n",
//						rx_counter, in_progress_count);
            continue; // wait for it in the next loop
		}

        /* process packet received here */
        process_packet(channel_ptr->buf_ptr[buffer_id].buffer, queue);

		/* Keep track how many transfers are in progress so that only the specified number
		 * of transfers are attempted
		 */
		in_progress_count--;

        /* Keep track of the number of 
         */
        rx_counter++;

		/* Start the next buffer again with another transfer keeping track of
		 * the number in progress but not finished
		 */
		ioctl(channel_ptr->fd, START_XFER, &buffer_id);

		in_progress_count++;

		/* Flip to next buffer treating them as a circular list, and possibly skipping some
		 * to show the results when prefetching is not happening
		 */
		buffer_id += BUFFER_INCREMENT;
		buffer_id %= RX_BUFFER_COUNT;

	}
}
