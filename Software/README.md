# Software: Time Sync + Pkt Gen for TSN Evaluation Toolkit

This repo contains source code to enable TSN Evaluation Toolkit's time synchronization logic and set up packet generation plan.

## Toolkit configuration

### Time synchronization

By default, the evaluation toolkit works as PTP slave clock.

To set up it as PTP master clock, change line 233-237 of "time_sync_main.c" file to:

```c
	per_ptp_instance_global.selectedState[0] = SLAVE_PORT;
	per_ptp_instance_global.selectedState[1] = MASTER_PORT;
	per_ptp_instance_global.selectedState[2] = DISABLED_PORT;
	per_ptp_instance_global.selectedState[3] = DISABLED_PORT;
	per_ptp_instance_global.selectedState[4] = DISABLED_PORT;
```

### Packet generation

The sample code and documentation of packet generation setup are shown in file "pkt_gen_control/pkt_gen.h".

## Build

```bash
mkdir build
cd build
cmake ..
make
```

After successfully build, there should be two executables: "time_sync_app" & "pkt_gen"

## Run

* Copy topology & schedule file to build dir

```bash
cp [topology name]-config.json build/topo.json
cp [topology name]-schedule.json build/schedule.json
```

* Start time syncronization

```bash
./time_sync
```

* Start device critical packet generation

```bash
./pkt_gen
```