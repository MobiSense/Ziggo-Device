#include "buffer_queue.h"
#include <stdlib.h>
#include <string.h>

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
        printf ("*** ERROR: buffer queue full, cannot push any element.\r\n");
        return 1;
    }
    if (len > MAX_PKT_LEN) {
        printf ("*** ERROR: input buffer length exceeds MAX_PKT_LEN. \r\n");
        return 1;
    }
    memcpy (queue->buf_array[queue->rear], buf, len);
    queue->len_array[queue->rear] = len;
    queue->rear = (queue->rear + 1 ) % FIFO_SIZE;
    queue->size += 1;
    printf ("finish push queue\r\n");
    return 0;
}

int pop_queue (buffer_queue *queue, uint8_t *buf, int *len) {
    if (queue->size <= 0) {
        printf ("*** ERROR: buffer queue empty, cannot pop any element.\r\n");
        return 1;
    }
    memcpy (buf, queue->buf_array[queue->front], queue->len_array[queue->front]);
    queue->front = (queue->front + 1 ) % FIFO_SIZE;
    queue->size -= 1;
    (*len) = queue->len_array[queue->front];
    return 0;
}
