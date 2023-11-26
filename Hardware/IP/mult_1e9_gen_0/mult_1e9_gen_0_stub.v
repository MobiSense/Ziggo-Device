// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Nov 28 19:51:26 2021
// Host        : Horace-TNS-win10 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top mult_1e9_gen_0 -prefix
//               mult_1e9_gen_0_ mult_1e9_gen_0_stub.v
// Design      : mult_1e9_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_16,Vivado 2020.1" *)
module mult_1e9_gen_0(A, P)
/* synthesis syn_black_box black_box_pad_pin="A[31:0],P[63:0]" */;
  input [31:0]A;
  output [63:0]P;
endmodule
