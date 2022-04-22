cmake_minimum_required(VERSION 3.0.0)
project(pkt_gen_app VERSION 0.1.0)

# SET(CMAKE_BUILD_TYPE Debug)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
ENDIF()

MESSAGE("Build type: " ${CMAKE_BUILD_TYPE})


set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O0 -Wall -lpthread  -march=native ")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O0 -Wall -lpthread   -march=native")

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g3 -Wall -lpthread  -march=native ")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g3 -Wall -lpthread   -march=native")


set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)


include_directories("${PROJECT_SOURCE_DIR}/dma_proxy" 
"${PROJECT_SOURCE_DIR}/time_sync" 
"${PROJECT_SOURCE_DIR}/pkt_gen_control")

link_directories("${PROJECT_SOURCE_DIR}/lib")

add_library(${PROJECT_NAME} SHARED
dma_proxy/buffer_queue.c
dma_proxy/dma-proxy.c
pkt_gen_control/pkt_gen.c
)

add_executable(time_sync_app time_sync_main.c)
target_link_libraries(time_sync_app ${PROJECT_NAME} time_sync)

add_executable(pkt_gen pkt_gen_main.c)
target_link_libraries(pkt_gen ${PROJECT_NAME} time_sync)

# add_executable(pkt_gen pkt_gen_main.cpp)
# target_link_libraries(pkt_gen ${PROJECT_NAME} time_sync)