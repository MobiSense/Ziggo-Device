// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Fri Jul  9 10:34:32 2021
// Host        : halcao-tns running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Projects/TSN/tsn_device/IP/axis_clock_converter_0/axis_clock_converter_0_stub.v
// Design      : axis_clock_converter_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "axis_clock_converter_v1_1_22_axis_clock_converter,Vivado 2020.1" *)
module axis_clock_converter_0(s_axis_aresetn, m_axis_aresetn, s_axis_aclk, 
  s_axis_tvalid, s_axis_tready, s_axis_tdata, s_axis_tlast, m_axis_aclk, m_axis_tvalid, 
  m_axis_tready, m_axis_tdata, m_axis_tlast)
/* synthesis syn_black_box black_box_pad_pin="s_axis_aresetn,m_axis_aresetn,s_axis_aclk,s_axis_tvalid,s_axis_tready,s_axis_tdata[7:0],s_axis_tlast,m_axis_aclk,m_axis_tvalid,m_axis_tready,m_axis_tdata[7:0],m_axis_tlast" */;
  input s_axis_aresetn;
  input m_axis_aresetn;
  input s_axis_aclk;
  input s_axis_tvalid;
  output s_axis_tready;
  input [7:0]s_axis_tdata;
  input s_axis_tlast;
  input m_axis_aclk;
  output m_axis_tvalid;
  input m_axis_tready;
  output [7:0]m_axis_tdata;
  output m_axis_tlast;
endmodule
