<div align="center">

# ZIGGO TSNPerf: A flexible and standard-compliant toolkit for TSN performance evaluation.

</div>

<h3 align="center">
    <a href="http://tns.thss.tsinghua.edu.cn/ziggo/">Project Page</a> |
    <a href="https://ieeexplore.ieee.org/document/10228980">Paper</a> |
    <a href="https://github.com/Horacehxw/Ziggo-CaaS-Switch">ZIGGO-CaaS-Switch</a> |
    <a href="https://github.com/Horacehxw/Ziggo-Evaluation-Toolkit">ZIGGO-TSNPerf</a> 
</h3>

![](figs/banner.jpg)

## Table of Contents

1. [Introduction](#introduction)

2. [ZIGGO Open Platform](#ziggo-open-platform)

3. [Demo](#demo)

4. [Features](#features)

5. [Getting Started](#getting-started)

6. [System Design](#system-design)

7. [Demo APP Tutorial](#demo-app-tutorial)

8. [License and Citation](#license-and-citation)

9. [TODO List](#todo-list)

10. [Contaction](#contaction)

## Introduction

ZIGGO is a `flexible`, `standard-compliant`, and `control-function-virtualized` TSN switch platform ready for **industrial control**, **automotive electronics**, and other **time-sensitive applications**.

This is the document for the ZIGGO TSNPerf. (We also offer [ZIGGO-Caas-Switch](https://github.com/Horacehxw/Ziggo-CaaS-Switch) that comply with the IEEE 802.1 TSN standard.) Our TSNPerf supports testing all standards-compliant switches.

## ZIGGO Open Platform

![](figs/demo-app.png)

The construction of the ZIGGO Open Platform consists of three levels: network device, management tools, and a Demo App:

- The software and hardware projects, along with the development board startup [tutorial](docs/getting-started.md), provide instructions for setting up an individual network device.

- The [CNC User Manual](docs/cnc-manual.md) and [TSNPerf User Manual](docs/tsnperf.md) cover system configuration and management tools.

- Lastly, we offer a comprehensive [Demo App building tutorial](docs/testbed.md) that instructs how to
  collaboratively build a complete and functional Demo using network devices and
  management tools.

## Demo

We provide a demonstration video of the TSN switch. It demonstrates the superior performance of the `ZIGGO-CaaS-Switch` compared to the normal switch.

The left side of the picture is the ZYNQ development board we use, and the right side is the TSN display board we built.

[![Watch the video](figs/testbed.jpg)](https://cloud.tsinghua.edu.cn/f/b307da6840d84e5f9ff1/)

> Click the pic to watch the video! Or just click [here](https://cloud.tsinghua.edu.cn/f/b307da6840d84e5f9ff1/).

## Features

* ZIGGO supports the simultaneous transmission of both `Information Technology (IT)` and `Operation Technology (OT)` data traffic with QoS guarantee.

* ZIGGO complies with IEEE standards `802.1AS`, `Qav`, `Qbv`, and `Qcc`.

* ZIGGO provides `Real-time` and `Deterministic` Ethernet transport
  
  * ZIGGO achieve **Zero Packet Loss** , **Microsecond-level Latency** with **Nanosecond-level Jitter Gate Ability**.
  * ZIGGO guarantee **Gigabit Throughput**.
  * ZIGGO provide gate accuracy applicable to **All Ethernet Frame Sizes**.

## Getting Started

Please refer to [getting_started.md](docs/getting-started.md) for the build and run a single ZIGGO TSNPerf.

## System Design

ZIGGO is implemented on ZYNQ-7000 SoC and exploits ZYNQ's both hardware and software programmability. 

![framework](figs/framework.jpg)

We also provide more in-depth [documentation](docs/system-design.md) explaining specific design principles for ZIGGO TSNPerf.

## Demo APP Tutorial

We also provide a [testbed build document](docs/testbed.md) that allows you to build a real-time Ethernet system using the ZIGGO swtich and TSNPerf. 

Through this platform, we can measure the `delay` and `jitter` of TSN time-critcial traffic, the switch's `gating capability`, `bandwidth guarantee` and `gating accuracy`. 

Replacing ZIGGO CaaS switches with commercial TSN switches can also test its above capabilities.

## License and Citation

ZIGGO is released under a [MIT license](LICENSE.txt). 

Please consider citing our papers if the project helps your research with the following BibTex:

```bibtex
@inproceedings{caas,
  author={Yang, Zheng and Zhao, Yi and Dang, Fan and He, Xiaowu and Wu, Jiahang and Cao, Hao and Wang, Zeyu and Liu, Yunhao},
  booktitle={IEEE INFOCOM 2023 - IEEE Conference on Computer Communications}, 
  title={CaaS: Enabling Control-as-a-Service for Time-Sensitive Networking}, 
  year={2023},
  pages={1-10},
  doi={10.1109/INFOCOM53939.2023.10228980}}
```

```bibtex
@inproceedings{etsn,
  author={Zhao, Yi and Yang, Zheng and He, Xiaowu and Wu, Jiahang and Cao, Hao and Dong, Liang and Dang, Fan and Liu, Yunhao},
  booktitle={IEEE ICDCS 2022 - IEEE International Conference on Distributed Computing Systems}, 
  title={E-TSN: Enabling Event-triggered Critical Traffic in Time-Sensitive Networking for Industrial Applications}, 
  year={2022},
  volume={},
  number={},
  pages={691-701},
  doi={10.1109/ICDCS54860.2022.00072}}
```

## TODO List

- [x] ZIGGO CaaS Switch Release
- [x] ZIGGO TSNPerf Release
- [x] ZIGGO TSNPerf Source Code
- [x] Tutorial for build a testbed
- [ ] Test Case for TSN

> We will expand each test in the tutorial to multiple test cases to cover different edge cases and comprehensively test the performance of TSN switches.

- [ ] Support Device List

> At present, we have only tested our own Ziggo switches and are testing other commercial switches (such as Huawei ,H3C and NXP). We expect to maintain a list of test results in the future.

## Contaction

If any questions and suggenstations, please email to admin@sense-lab.org. Or you can also consider raising an issue on github.