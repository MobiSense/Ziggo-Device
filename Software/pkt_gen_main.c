#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include "pkt_gen_control/pkt_gen.h"
#include "config.h"

int config_pkt_gen_ring3 () {
    start_pkt_gen_config(25);

    uint8_t mac_device_0[6] = {0x00, 0x0A, 0x35, 0x00, 0x1E, 0x00};
    uint8_t mac_device_1[6] = {0x00, 0x0A, 0x35, 0x00, 0x1E, 0x01};
    uint8_t mac_device_2[6] = {0x00, 0x0A, 0x35, 0x00, 0x1E, 0x02};
    uint8_t mac_device_3[6] = {0x00, 0x0A, 0x35, 0x00, 0x1E, 0x03};
    uint8_t mac_device_4[6] = {0x00, 0x0A, 0x35, 0x00, 0x1E, 0x04};
    uint8_t mac_switch_0[6] = {0x00, 0x0A, 0x35, 0x00, 0x00, 0x53};
    uint8_t mac_switch_1[6] = {0x00, 0x0A, 0x35, 0x00, 0x01, 0x53};
    uint8_t mac_switch_2[6] = {0x00, 0x0A, 0x35, 0x00, 0x02, 0x53};
    uint8_t mac_switch_3[6] = {0x00, 0x0A, 0x35, 0x00, 0x03, 0x53};

    set_pkt_gen_slot (0, 0x0103, 1, 0, 2, 1<<14, mac_device_2, mac_switch_3);
    set_pkt_gen_slot (1, 0x0103, 1, 1, 2, (1<<14)+(1024<<14), mac_device_2, mac_switch_3);
    set_pkt_gen_slot (2, 0x0000, 1, 0, 1, 1179<<14, mac_device_2, mac_switch_2);

    finish_pkt_gen_config();
}


int main() {
    pkt_gen_init();

    config_pkt_gen_ring3 ();

    return 0;
}
