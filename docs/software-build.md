# Time Sync + Pkt Gen for CaaS Device

This repo contains source code to enable TSN/CaaS Device' time synchronization logic and set up packet generation plan.

## Table of Content

- [1. Build](#1-build)
- [2. Config](#2-config)
- [3. Run](#3-run)
- [4. Analyze](#4-analyze)
  - [4.1 Device directly analyzes latency and jitter](#41-Device-directly-analyzes-latency-and-jitter)
  - [4.2 Offline analysis of latency and jitter](#42-offline-analysis-of-latency-and-jitter)

## 1. Build

```bash
mkdir build
cd build
cmake ..
make
```

After successfully build, there should be two executables: "time_sync" & "pkt_gen"

## 2. Config

The "build" directory contains topology & TSN/CaaS schedule results.

* config.json: topology file, contains node info (type, mac, ptp ports), link between nodes (with ports), and forwarding table.
* schedule.json: schedule file, contains each links' schedule time interval & each CaaS switch's computation time interval.

(Hints: This is similar to a Ziggo Switch)

## 3. Run

* Start time syncronization

```bash
./time_sync
```

* Start device critical packet generation

```bash
./pkt_gen
```

## 4. Analyze

There are two analysis methods for Device:

> Hint: If you want to use offline anaylze, please switch branch to 'offline_anaylze', and you need to link device to anthor PC(linux) by wire.

One method is to directly analyze latency and jitter on the Device. 

Another method is to use Device to stamp the received packet and forward it from another port to a powerful desktop computer for packet capture analysis. Even if entering the Device at a gigabit rate, there will be no packet loss. The disadvantage is that a separate program needs to be written offline to analyze the delay and jitter of the packet.

### 4.1 Device directly analyzes latency and jitter

During the operation of the  `time sync` program, after receiving the test data frame, the program will save the delay information of the data frame in the package under the `build/packet_log.csv`   file, save the batch statistics of latency and jitter in the critical directory under the build directory at the same time in the `build/critical_log.csv`.

You can display the content of the header and the last 5 lines using the following command:

```bash
cat critical.log | head -n1
cat critical.log | tail -n5
```

### 4.2 Offline analysis of latency and jitter

If conducting offline analysis, it is important to note that the hardware used is located at `offline_analyze` branch. This version will stamp the key data with a receive timestamp and forward it from ETH2. We need to use a PC equipped with a Linux system to capture packets for analysis.

Example of packet capture command:

```bash
sudo tcpdump -i enx207bd272812b ether src 00:0a:35:00:00:14 -n -B 100000 -w packets.pcapng
```

`Enx207bd272812b` is the name of the network card, which can be obtained through ifconfig. `Src` is used to specify that the captured packet comes from a certain MAC address. `-B` is used to specify the buffer size. If packet loss needs to be set to a larger size, you can check the information output after packet capture to see if Dropped by kernel: is 0. If it is not 0, it indicates that there is packet loss in the kernel. `-W` specifies the path to save the file.

Code for analyzing programs is `analyze_packet.py`

```bash
python .\analyze_packet.py [capture file path] --step [interval]
```

At the same time, a packet will be generated in the current directory (`packet_log.csv` and `critical_log.csv`).
