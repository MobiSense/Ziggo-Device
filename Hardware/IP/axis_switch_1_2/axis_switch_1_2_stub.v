// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Tue Apr 26 21:31:14 2022
// Host        : DESKTOP-5H7SBV0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub d:/repositories/tsn_device/IP/axis_switch_1_2/axis_switch_1_2_stub.v
// Design      : axis_switch_1_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_switch_v1_1_21_axis_switch,Vivado 2020.1" *)
module axis_switch_1_2(aclk, aresetn, s_axis_tvalid, s_axis_tready, 
  s_axis_tdata, s_axis_tlast, s_axis_tdest, m_axis_tvalid, m_axis_tready, m_axis_tdata, 
  m_axis_tlast, m_axis_tdest, s_decode_err)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_tvalid[0:0],s_axis_tready[0:0],s_axis_tdata[7:0],s_axis_tlast[0:0],s_axis_tdest[0:0],m_axis_tvalid[1:0],m_axis_tready[1:0],m_axis_tdata[15:0],m_axis_tlast[1:0],m_axis_tdest[1:0],s_decode_err[0:0]" */;
  input aclk;
  input aresetn;
  input [0:0]s_axis_tvalid;
  output [0:0]s_axis_tready;
  input [7:0]s_axis_tdata;
  input [0:0]s_axis_tlast;
  input [0:0]s_axis_tdest;
  output [1:0]m_axis_tvalid;
  input [1:0]m_axis_tready;
  output [15:0]m_axis_tdata;
  output [1:0]m_axis_tlast;
  output [1:0]m_axis_tdest;
  output [0:0]s_decode_err;
endmodule
