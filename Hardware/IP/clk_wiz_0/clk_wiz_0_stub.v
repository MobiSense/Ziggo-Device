// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Thu Jun 17 21:20:55 2021
// Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_wiz_0 -prefix
//               clk_wiz_0_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk125, clk200, clk50, reset, locked, sys_clk)
/* synthesis syn_black_box black_box_pad_pin="clk125,clk200,clk50,reset,locked,sys_clk" */;
  output clk125;
  output clk200;
  output clk50;
  input reset;
  output locked;
  input sys_clk;
endmodule
