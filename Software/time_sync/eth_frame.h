#ifndef ETH_FRAME_H
#define ETH_FRAME_H

#include "../tsn_drivers/ptp_types.h"
#include "../dma_proxy/buffer_queue.h"
#include <stdint.h>

typedef enum {RECV_FRAME = 0, RECV_NOTHING = 1} RecvStatus;

void send_ptp_frame(uint8_t *buffer, int length, uint16_t portNumber, char* msg_type, uint16_t seq_id);
PTPMsgType recv_ptp_frame(uint8_t **buffer_ptr_ptr, TSUTimestamp **ts_ptr_ptr, uint16_t *port_number_ptr,
        buffer_queue *queue);
#endif
