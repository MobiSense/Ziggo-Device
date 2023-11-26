#include "buffer_queue.h"
#include <stdlib.h>
#include <string.h>
#include "../log/log.h"

#define MAX_PKT_LEN		    1600

int init_queue (buffer_queue *queue) {
    queue->front = 0;
    queue->rear = 0;
    queue->size = 0;
    for (int i = 0; i < FIFO_SIZE; i++) {
        queue->buf_array[i] = (uint8_t *) malloc (MAX_PKT_LEN+1);
        queue->len_array[i] = 0;
    }
}

int push_queue (buffer_queue *queue, uint8_t *buf, int len) {
    if (queue->size >= FIFO_SIZE) {
        log_error("buffer queue full, cannot push any element.\r\n");
        exit(EXIT_FAILURE);
    }
    if (len > MAX_PKT_LEN) {
        log_error("input buffer length exceeds MAX_PKT_LEN. \r\n");
        exit(EXIT_FAILURE);
    }
    memcpy (queue->buf_array[queue->rear], buf, len);
    queue->len_array[queue->rear] = len;
    queue->rear = (queue->rear + 1 ) % FIFO_SIZE;
    queue->size += 1;
    // printf ("finish push queue\r\n");
    return 0;
}

int pop_queue (buffer_queue *queue, uint8_t *buf, int *len) {
    if (queue->size <= 0) {
        log_error("buffer queue empty, cannot pop any element.\r\n");
        exit(EXIT_FAILURE);
    }
    memcpy (buf, queue->buf_array[queue->front], queue->len_array[queue->front]);
    queue->front = (queue->front + 1 ) % FIFO_SIZE;
    queue->size -= 1;
    (*len) = queue->len_array[queue->front];
    return 0;
}
