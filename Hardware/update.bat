@echo off
cmd.exe /c "vivado -mode batch -source tsn_device.tcl"
rmdir /s /q Work_Dir
ren tns_tsn_device Work_Dir