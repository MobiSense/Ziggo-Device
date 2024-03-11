# 准备清单

## 软件环境清单

### Vivada 开发环境

Vivado 是开发板的硬件开发程序。

Vivado 软件的 Xilinx 官方下载地址： http://china.xilinx.com/support/download.html  

本开发团队使用的是Vivado ***2020.1***版本，我们建议ZIGGO项目使用者也使用相同版本以免一些不必要的麻烦。

具体的安装流程可以参照 [ZYNQ应用教程](https://cloud.tsinghua.edu.cn/f/f9f1a4f92a344e8e9c2c/) **第三章Vivado开发环境** 进行安装。

### MobaXterm

MobaXterm是串口连接工具，我们在[hardware_build.md](./hardware_build.md)中“Launch the Board and log in”这一章节进行了使用介绍。

MobaXterm的官方下载地址：[MobaXterm Xserver with SSH, telnet, RDP, VNC and X11 - Download (mobatek.net)](https://mobaxterm.mobatek.net/download.html)

## 硬件准备清单

### Alinx7021开发板

<img src="../figs/Alinx7021.png" alt="Alinx7021" style="zoom:50%;" />

### SD启动卡

SD启动卡中存储着操作系统，建议容量 $\geq$ 32G。

### 必要的线材

包括网线、数据线等。

### 普通交换机

如果使用的开发板数量较多，可以考虑将所有开发板连接到普通交换机再通过普通交换机连接至PC（通过网线）进行管理和使用。