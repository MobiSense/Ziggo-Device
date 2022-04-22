#ifndef BUFFER_QUEUE_H
#define BUFFER_QUEUE_H

#include <stdint.h>
/**
 * @brief cyclic FIFO queue to store PTP related packets received by DMA
 * It will be accessed in a producer-consumer way between DMA_rx and time_sync thread
 */
#define FIFO_SIZE 64
typedef struct {
	int front;
	int rear;
	int size;
	uint8_t *buf_array[FIFO_SIZE];
	int len_array[FIFO_SIZE];
} buffer_queue;

int init_queue (buffer_queue *queue);

/**
 * @brief push a buf to the rear of buffer queue
 * Can only be called if size is smaller than FIFO_SIZE
 * 
 * @param queue 
 * @param buf source buffer pointer
 * @param len length of source buffer
 * @return int 0 if success, 1 if fail
 */
int push_queue (buffer_queue *queue, uint8_t *buf, int len);

/**
 * @brief get the front buf from buffer queue
 * Can only be called if size is not 0
 * 
 * @param queue 
 * @param buf destination buffer pointer
 * @param len pointer to length, assign value to it
 * @return int 
 */
int pop_queue (buffer_queue *queue, uint8_t *buf, int *len);

#endif