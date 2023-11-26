cmake_minimum_required(VERSION 3.0.0)
project(pkt_gen_app VERSION 0.1.0)

# SET(CMAKE_BUILD_TYPE Debug)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})


set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O0 -Wall -lpthread -lm  -march=native -DLOG_USE_COLOR")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O0 -Wall -lpthread -lm   -march=native -DLOG_USE_COLOR")

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g3 -Wall -lpthread -lm  -march=native -DLOG_USE_COLOR")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g3 -Wall -lpthread -lm   -march=native -DLOG_USE_COLOR")


set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)


include_directories("${PROJECT_SOURCE_DIR}/dma_proxy" 
"${PROJECT_SOURCE_DIR}/time_sync" 
"${PROJECT_SOURCE_DIR}/pkt_gen_control"
"${PROJECT_SOURCE_DIR}/log"
"${PROJECT_SOURCE_DIR}/tsn_drivers")

add_library(${PROJECT_NAME} SHARED
dma_proxy/buffer_queue.c
dma_proxy/dma-proxy.c
pkt_gen_control/pkt_gen.c
time_sync/clock_master_sync_receive_sm.c
time_sync/clock_master_sync_send_sm.c
time_sync/clock_slave_sync_sm.c
time_sync/eth_frame.c
time_sync/md_pdelay_req_sm.c
time_sync/md_pdelay_resp_sm.c
time_sync/md_sync_receive_sm.c
time_sync/md_sync_send_sm.c
time_sync/msg_frame.c
time_sync/port_sync_sync_receive_sm.c
time_sync/port_sync_sync_send_sm.c
time_sync/site_sync_sync_sm.c
tsn_drivers/tsu.c
tsn_drivers/uio.c
tsn_drivers/rtc.c
tsn_drivers/gcl.c
tsn_drivers/gpio_reset.c
tsn_drivers/ptp_types.c
log/log.c
)

add_executable(time_sync time_sync_main.c)
target_link_libraries(time_sync ${PROJECT_NAME})

# add_executable(pkt_gen pkt_gen_main.c)
# target_link_libraries(pkt_gen ${PROJECT_NAME})

add_executable(pkt_gen pkt_gen_main.cpp)
target_link_libraries(pkt_gen ${PROJECT_NAME})