#!/bin/bash
/mnt/c/Windows/System32/cmd.exe /c "vivado -mode batch -source tsn_device.tcl"
rm -rf Work_Dir
mv tns_tsn_device Work_Dir
