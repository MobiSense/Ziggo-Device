# Hardware: FPGA bitstream & Petalinux system rootfs for TSN Evaluation Toolkit

This repo contains pre-build hardware & system rootfs to boot the **Zynq AX7021** FPGA board from SD card.

## File downloading

Download the following file from [this](https://cloud.tsinghua.edu.cn/d/fa68c30f514144c0872b/) public link:

* BOOT.BIN
* boot.scr
* image.ub
* rootfs.tar.gz


## SD card partition

In order to boot the TSN Evaluation toolkit, you are supposed to have a micro SD card with >32GiB storage. Then use:

```bash
sudo apt-get install gparted
sudo gparted
```

Parition it into two partition below

* BOOT: store boot files from petalinux

    Free space preceding (MiB): 4

    New size (MiB): 500

    File system: fat32

    Label: BOOT

* ROOTFS: store debian system rootfs

    Free space preceding (MiB): 0

    Free space following (MiB): 0

    File system: ext4

    Label: ROOTFS

## Copy files into SD card

Mound SD card:
```bash
sudo mount /dev/sda1 /media/alinx/BOOT/
sudo mount /dev/sda2 /media/alinx/ROOTFS/
```

Remove original files:
```bash
sudo rm -rf /media/alinx/BOOT/* /media/alinx/ROOTFS/*
```

Copy files:
```bash
sudo cp BOOT.BIN boot.scr image.ub /media/alinx/BOOT

sudo tar -zxvf rootfs.tar.gz -C /media/alinx/ROOTFS
sudo cp -r ~/init_os.sh /media/alinx/ROOTFS/home/root/init_os.sh 
sync
sudo chown root:root /media/alinx/ROOTFS
sudo chmod 755 /media/alinx/ROOTFS
```

## Launch the toolkit

Plug in SD card, setup AX7021 board to boot on SD, power on.

Afterwards, you can build and run the Software part.