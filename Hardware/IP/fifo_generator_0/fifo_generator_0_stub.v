// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Nov 28 12:26:17 2021
// Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top fifo_generator_0 -prefix
//               fifo_generator_0_ fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.1" *)
module fifo_generator_0(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, rd_data_count, wr_data_count)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[127:0],wr_en,rd_en,dout[127:0],full,empty,rd_data_count[3:0],wr_data_count[3:0]" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [127:0]din;
  input wr_en;
  input rd_en;
  output [127:0]dout;
  output full;
  output empty;
  output [3:0]rd_data_count;
  output [3:0]wr_data_count;
endmodule
